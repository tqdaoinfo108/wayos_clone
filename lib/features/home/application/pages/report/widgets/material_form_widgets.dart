import 'package:flutter/material.dart';

class MaterialFormWidgets {
  static Widget buildDropdownField({
    required String label,
    required String hint,
    required int? value,
    required List<DropdownMenuItem<int>> items,
    required ValueChanged<int?> onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: value,
          items: items,
          onChanged: onChanged,
          decoration: _inputDecoration(hint, icon),
        ),
      ],
    );
  }

  static Widget buildAutocompleteField({
    required String label,
    required String hint,
    required List<Map<String, dynamic>> items,
    required TextEditingController controller,
    required Function(Map<String, dynamic>) onSelected,
    required String Function(Map<String, dynamic>) displayStringForOption,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
        const SizedBox(height: 8),
        Autocomplete<Map<String, dynamic>>(
          optionsBuilder: (textEditingValue) {
            if (textEditingValue.text.isEmpty) return const Iterable.empty();
            return items.where((item) => displayStringForOption(item).toLowerCase().contains(textEditingValue.text.toLowerCase()));
          },
          displayStringForOption: displayStringForOption,
          onSelected: onSelected,
          fieldViewBuilder: (ctx, textEditingController, focusNode, onFieldSubmitted) {
            if (controller.text.isNotEmpty && textEditingController.text.isEmpty) {
              textEditingController.text = controller.text;
            }
            return TextField(
              controller: textEditingController,
              focusNode: focusNode,
              onChanged: (val) => controller.text = val,
              decoration: _inputDecoration(hint, icon),
            );
          },
          optionsViewBuilder: (ctx, onSel, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200, maxWidth: 400),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (ctx, i) {
                      final option = options.elementAt(i);
                      return InkWell(
                        onTap: () => onSel(option),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Icon(icon, size: 20, color: Colors.grey.shade600),
                              const SizedBox(width: 12),
                              Expanded(child: Text(displayStringForOption(option), style: TextStyle(fontSize: 14, color: Colors.grey.shade800))),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  static Widget buildTitleField(TextEditingController controller, bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tiêu đề *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: false,
          minLines: 2,
          maxLines: 3,
          decoration: _inputDecoration('Tiêu đề sẽ được tự động tạo', Icons.title, disabled: true).copyWith(
            prefixIcon: isLoading 
              ? const Padding(padding: EdgeInsets.all(12), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)))
              : Icon(Icons.title, color: Colors.grey.shade400),
            suffixIcon: !isLoading && controller.text.isNotEmpty ? const Icon(Icons.check_circle, color: Colors.green) : null,
          ),
        ),
      ],
    );
  }

  static Widget buildTextField({required String label, required TextEditingController controller, required IconData icon, TextInputType type = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: type,
          decoration: _inputDecoration('Nhập ${label.toLowerCase().replaceAll('*', '').trim()}', icon),
        ),
      ],
    );
  }

  static InputDecoration _inputDecoration(String hint, IconData icon, {bool disabled = false}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey.shade500),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue, width: 2)),
      disabledBorder: disabled ? OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)) : null,
      filled: true,
      fillColor: disabled ? Colors.grey.shade100 : Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}
