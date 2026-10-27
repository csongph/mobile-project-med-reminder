import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/state/app_state.dart';
import '../models/medication.dart';
import '../services/medication_label_parser.dart';
import '../../schedules/models/schedule.dart';

class AddEditMedicationScreen extends ConsumerStatefulWidget {
  final Medication? existingMedication;

  const AddEditMedicationScreen({super.key, this.existingMedication});

  @override
  ConsumerState<AddEditMedicationScreen> createState() =>
      _AddEditMedicationScreenState();
}

class _AddEditMedicationScreenState
    extends ConsumerState<AddEditMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _notesController;
  int _quantity = 30;
  int _threshold = 5;
  int _dosePerTime = 1;
  int _step = 0;
  String? _labelImagePath;
  String _recognizedText = '';
  List<String> _nameCandidates = [];
  bool _isScanning = false;
  bool _isSaving = false;

  List<String> _times = ['08:00'];
  List<int> _daysOfWeek = [1, 2, 3, 4, 5, 6, 7]; // จันทร์ถึงอาทิตย์

  @override
  void initState() {
    super.initState();
    final med = widget.existingMedication;
    _nameController = TextEditingController(text: med?.name ?? '');
    _notesController = TextEditingController(text: med?.notes ?? '');
    _quantity = med?.quantity ?? 30;
    _threshold = med?.lowStockThreshold ?? 5;

    if (med != null) {
      _step = 1;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final state = ref.read(appStateProvider);
        final sch = state.schedules.firstWhere(
          (s) => s.medId == med.id,
          orElse: () => Schedule(
            id: '',
            medId: med.id,
            times: ['08:00'],
            daysOfWeek: [1, 2, 3, 4, 5, 6, 7],
          ),
        );
        setState(() {
          _times = List.from(sch.times);
          _daysOfWeek = List.from(sch.daysOfWeek);
          _dosePerTime = sch.dosePerTime;
        });
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
    );
    if (picked != null) {
      final formatted =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      if (!_times.contains(formatted)) {
        setState(() {
          _times.add(formatted);
          _times.sort();
        });
      }
    }
  }

  Future<void> _scanLabel() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('ถ่ายรูปฉลากยา'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('เลือกรูปจากคลังภาพ'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    try {
      final image = await ImagePicker().pickImage(
        source: source,
        imageQuality: 100,
        maxWidth: 2400,
        maxHeight: 2400,
      );
      if (image == null) return;
      setState(() {
        _isScanning = true;
        _labelImagePath = image.path;
      });
      final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
      try {
        final result = await recognizer.processImage(
          InputImage.fromFilePath(image.path),
        );
        final text = result.text.trim();
        if (text.isEmpty) {
          throw Exception(
            'อ่านข้อความในภาพไม่ได้ ลองถ่ายใหม่ให้ชัดและมีแสงเพียงพอ',
          );
        }
        final parsed = MedicationLabelParser.parse(result);
        if (!mounted) return;
        setState(() {
          _recognizedText = text;
          _nameCandidates = parsed.nameCandidates;
          if (_notesController.text.trim().isEmpty &&
              parsed.instructions.isNotEmpty) {
            _notesController.text = parsed.instructions;
          }
          if (parsed.quantity != null) _quantity = parsed.quantity!;
          _step = 1;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'สแกนแล้ว เลือกชื่อยาที่ตรงกับฉลากและตรวจสอบข้อมูลก่อนบันทึก',
            ),
          ),
        );
      } finally {
        await recognizer.close();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('สแกนฉลากไม่สำเร็จ: $error')));
      }
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  Future<void> _saveMedication() async {
    if (!_formKey.currentState!.validate()) return;
    if (_times.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาระบุเวลาทานยาอย่างน้อย 1 เวลา')),
      );
      return;
    }

    if (_isSaving) return;
    setState(() => _isSaving = true);
    final notifier = ref.read(appStateProvider.notifier);
    final currentState = ref.read(appStateProvider);
    var shouldShowPermissionMessage = false;
    var permissionGranted = false;
    try {
      permissionGranted =
          currentState.remindersEnabled &&
          await NotificationService().notificationsAllowed();
      if (!permissionGranted &&
          ((!currentState.remindersEnabled &&
                  widget.existingMedication == null) ||
              currentState.remindersEnabled)) {
        shouldShowPermissionMessage = true;
        permissionGranted = await NotificationService().requestPermissions(
          requestFullScreenIntent: true,
        );
      }
    } catch (_) {
      permissionGranted = false;
      shouldShowPermissionMessage =
          currentState.remindersEnabled || widget.existingMedication == null;
    }
    try {
      if (permissionGranted && !currentState.remindersEnabled) {
        await notifier.setRemindersEnabled(true);
      } else if (!permissionGranted && currentState.remindersEnabled) {
        await notifier.setRemindersEnabled(false);
      }

      if (widget.existingMedication == null) {
        await notifier.addMedication(
          name: _nameController.text.trim(),
          quantity: _quantity,
          lowStockThreshold: _threshold,
          notes: _notesController.text.trim(),
          times: _times,
          daysOfWeek: _daysOfWeek,
          dosePerTime: _dosePerTime,
        );
      } else {
        final updatedMed = widget.existingMedication!.copyWith(
          name: _nameController.text.trim(),
          quantity: _quantity,
          lowStockThreshold: _threshold,
          notes: _notesController.text.trim(),
        );
        final updatedSch = Schedule(
          id: 'sch_${updatedMed.id}',
          medId: updatedMed.id,
          times: _times,
          daysOfWeek: _daysOfWeek,
          dosePerTime: _dosePerTime,
        );
        await notifier.updateMedication(updatedMed, updatedSch);
      }

      if (!mounted) return;
      if (shouldShowPermissionMessage && !permissionGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'บันทึกตารางยาแล้ว แต่ยังไม่มีการเตือน กรุณาอนุญาตการแจ้งเตือนในการตั้งค่า Android',
            ),
            duration: Duration(seconds: 5),
          ),
        );
      }
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('บันทึกไม่สำเร็จ กรุณาลองอีกครั้ง')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingMedication != null;
    final dayNames = ['จ', 'อ', 'พ', 'พฤ', 'ศ', 'ส', 'อา'];
    final steps = isEditing
        ? const ['ข้อมูลยา', 'ตั้งเวลา', 'ยืนยัน']
        : const ['สแกนฉลาก', 'ตรวจข้อมูล', 'ตั้งเวลา', 'ยืนยัน'];
    final visibleStep = isEditing ? (_step - 1).clamp(0, 2) : _step;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(isEditing ? 'แก้ไขรายการยา' : 'เพิ่มยาใหม่'),
        actions: [
          if (_step > 0)
            TextButton(
              onPressed: () => setState(() => _step--),
              child: const Text('ย้อนกลับ'),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Row(
                children: List.generate(steps.length, (index) {
                  final selected = index == visibleStep;
                  final done = index < visibleStep;
                  return Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selected || done
                                ? AppTheme.primary
                                : AppTheme.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: selected || done
                                  ? Colors.white
                                  : AppTheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            steps[index],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: selected
                                  ? AppTheme.primary
                                  : AppTheme.secondary,
                              fontSize: 12,
                              fontWeight: selected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (index < steps.length - 1)
                          Expanded(
                            child: Container(
                              height: 1,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              color: done ? AppTheme.primary : AppTheme.border,
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                children: [
                  if (_step == 0) ...[
                    const SectionHeader(title: 'สแกนฉลากยา'),
                    InkWell(
                      onTap: _isScanning ? null : _scanLabel,
                      borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                      child: Container(
                        height: 300,
                        decoration: BoxDecoration(
                          color: AppTheme.dark,
                          borderRadius: BorderRadius.circular(
                            AppTheme.cardRadius,
                          ),
                        ),
                        child: Center(
                          child: _isScanning
                              ? const CircularProgressIndicator(
                                  color: AppTheme.accent,
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.document_scanner_rounded,
                                      size: 48,
                                      color: AppTheme.accent,
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'จัดชื่อยาและความแรงให้อยู่กลางภาพ และถ่ายให้คมชัด',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    const Text(
                                      'แตะเพื่อเปิดกล้องหรือเลือกรูป',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    const SizedBox(height: 16),
                                    OutlinedButton.icon(
                                      onPressed: _scanLabel,
                                      icon: const Icon(
                                        Icons.camera_alt_outlined,
                                      ),
                                      label: const Text('เปิดกล้อง / คลังภาพ'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        side: const BorderSide(
                                          color: AppTheme.accent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'ถ่ายในที่สว่างและหลีกเลี่ยงแสงสะท้อน · OCR อ่านอักษรอังกฤษได้ดีกว่าอักษรไทย กรุณาตรวจชื่อยาก่อนบันทึก',
                      style: TextStyle(color: AppTheme.secondary),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () => setState(() => _step = 1),
                      child: const Text('กรอกข้อมูลเอง'),
                    ),
                  ],
                  if (_step == 1) ...[
                    if (_labelImagePath != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryContainer,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              color: AppTheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _recognizedText.isEmpty
                                    ? 'เลือกรูปฉลากแล้ว'
                                    : 'อ่านข้อความจากฉลากแล้ว · กรุณาตรวจสอบข้อมูล',
                              ),
                            ),
                            TextButton(
                              onPressed: _scanLabel,
                              child: const Text('ถ่ายใหม่'),
                            ),
                          ],
                        ),
                      ),
                    if (_recognizedText.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'ข้อความที่อ่านได้',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primary,
                              ),
                            ),
                            if (_recognizedText.isNotEmpty)
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: AppTheme.border),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'เลือกชื่อยาที่ตรงกับฉลาก',
                                      style: TextStyle(
                                        color: AppTheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _nameCandidates.isEmpty
                                          ? 'ยังจับคู่ชื่อยาไม่ได้ กรุณาพิมพ์ชื่อตามฉลากด้วยตนเอง'
                                          : 'แตะตัวเลือกเพื่อใส่ชื่อยา แล้วตรวจทานอีกครั้ง',
                                      style: const TextStyle(
                                        color: AppTheme.secondary,
                                      ),
                                    ),
                                    if (_nameCandidates.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 4,
                                        children: _nameCandidates
                                            .map(
                                              (candidate) => ActionChip(
                                                label: Text(candidate),
                                                onPressed: () => setState(() {
                                                  _nameController.text =
                                                      candidate;
                                                  _nameController.selection =
                                                      TextSelection.collapsed(
                                                        offset:
                                                            candidate.length,
                                                      );
                                                }),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            const SizedBox(height: 6),
                            Text(
                              _recognizedText,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    // ปุ่ม AI Scan เด่นที่ด้านบน
                    if (isEditing)
                      InkWell(
                        onTap: _scanLabel,
                        borderRadius: BorderRadius.circular(
                          AppTheme.cardRadius,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(
                              AppTheme.cardRadius,
                            ),
                            boxShadow: AppTheme.softShadow,
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.document_scanner_rounded,
                                color: Colors.white,
                                size: 32,
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'สแกนฉลากยาด้วย AI (OCR)',
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontHeading,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'ถ่ายรูปฉลากเพื่อเติมข้อมูลอัตโนมัติ',
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontBody,
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),

                    // 1. ข้อมูลยา
                    const SectionHeader(title: '1. ข้อมูลยา 📋'),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'ชื่อยา *',
                        hintText: 'เช่น พาราเซตามอล (500 mg)',
                        prefixIcon: Icon(
                          Icons.medication_rounded,
                          color: AppTheme.primary,
                        ),
                      ),
                      validator: (val) => (val == null || val.trim().isEmpty)
                          ? 'กรุณากรอกชื่อยา'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // จำนวนยา และเกณฑ์แจ้งเตือน
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                AppTheme.cardRadius,
                              ),
                              border: Border.all(color: AppTheme.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'จำนวนคงเหลือ (เม็ด)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.secondary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      visualDensity: VisualDensity.compact,
                                      onPressed: () => setState(
                                        () => _quantity = (_quantity - 1).clamp(
                                          0,
                                          9999,
                                        ),
                                      ),
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                        color: AppTheme.primary,
                                        size: 28,
                                      ),
                                    ),
                                    Text(
                                      '$_quantity',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      visualDensity: VisualDensity.compact,
                                      onPressed: () =>
                                          setState(() => _quantity += 1),
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                        color: AppTheme.primary,
                                        size: 28,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                AppTheme.cardRadius,
                              ),
                              border: Border.all(color: AppTheme.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'เตือนเมื่อเหลือต่ำกว่า',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.secondary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      visualDensity: VisualDensity.compact,
                                      onPressed: () => setState(
                                        () => _threshold = (_threshold - 1)
                                            .clamp(1, 99),
                                      ),
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                        color: AppTheme.statusLowStock,
                                        size: 28,
                                      ),
                                    ),
                                    Text(
                                      '$_threshold',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      visualDensity: VisualDensity.compact,
                                      onPressed: () =>
                                          setState(() => _threshold += 1),
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                        color: AppTheme.statusLowStock,
                                        size: 28,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    PrimaryButton(
                      label: 'ตรวจข้อมูลและไปตั้งเวลา',
                      icon: Icons.arrow_forward_rounded,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() => _step = 2);
                        }
                      },
                    ),
                  ],
                  if (_step == 2) ...[
                    // 2. ตั้งเวลาทาน
                    const SectionHeader(title: '2. ตารางเวลาและความถี่ ⏰'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ..._times.map(
                          (t) => Chip(
                            label: Text(
                              t,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primary,
                              ),
                            ),
                            backgroundColor: AppTheme.primaryContainer,
                            deleteIcon: const Icon(
                              Icons.close_rounded,
                              size: 18,
                            ),
                            onDeleted: () => setState(() => _times.remove(t)),
                          ),
                        ),
                        ActionChip(
                          avatar: const Icon(
                            Icons.add_alarm_rounded,
                            color: AppTheme.primary,
                            size: 20,
                          ),
                          label: const Text('เพิ่มเวลา'),
                          backgroundColor: Colors.white,
                          onPressed: _pickTime,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ความถี่วันในสัปดาห์
                    const Text(
                      'วันที่ต้องทาน:',
                      style: TextStyle(
                        fontFamily: AppTheme.fontBody,
                        fontSize: 16,
                        color: AppTheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(7, (i) {
                        final dayNumber = i + 1;
                        final isSelected = _daysOfWeek.contains(dayNumber);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                if (_daysOfWeek.length > 1) {
                                  _daysOfWeek.remove(dayNumber);
                                }
                              } else {
                                _daysOfWeek.add(dayNumber);
                                _daysOfWeek.sort();
                              }
                            });
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.primary
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.primary
                                    : AppTheme.border,
                              ),
                            ),
                            child: Text(
                              dayNames[i],
                              style: TextStyle(
                                fontFamily: AppTheme.fontHeading,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.primary,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),

                    // 3. รายละเอียดการใช้
                    const SectionHeader(title: '3. รายละเอียดเพิ่มเติม 📝'),
                    TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'คำแนะนำการใช้ยา',
                        hintText: 'เช่น ทานหลังอาหารทันที ดื่มน้ำตามมากๆ',
                      ),
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      label: 'ตรวจสอบข้อมูลทั้งหมด',
                      icon: Icons.arrow_forward_rounded,
                      onPressed: () {
                        if (_nameController.text.trim().isEmpty) {
                          _formKey.currentState!.validate();
                          return;
                        }
                        setState(() => _step = 3);
                      },
                    ),
                  ],
                  if (_step == 3) ...[
                    const SectionHeader(title: 'สรุปข้อมูลยา'),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          AppTheme.cardRadius,
                        ),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _nameController.text,
                            style: const TextStyle(
                              fontFamily: AppTheme.fontHeading,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'คงเหลือ $_quantity เม็ด · ครั้งละ $_dosePerTime เม็ด',
                          ),
                          Text('เวลา ${_times.join(' · ')}'),
                          Text(
                            'วันที่ ${_daysOfWeek.map((day) => dayNames[day - 1]).join(' ')}',
                          ),
                          if (_notesController.text.trim().isNotEmpty)
                            Text('คำแนะนำ: ${_notesController.text.trim()}'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      icon: Icons.save_rounded,
                      label: _isSaving
                          ? 'กำลังบันทึก…'
                          : isEditing
                          ? 'บันทึกการแก้ไข'
                          : 'บันทึกยาและตั้งเตือน',
                      onPressed: _isSaving ? null : _saveMedication,
                    ),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
