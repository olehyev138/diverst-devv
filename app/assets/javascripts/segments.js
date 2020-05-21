$(document).on('ready page:load', function(){
  var operators = [{
    id: 0,
    name: "equals",
    isMultiSelect: false
  }, {
    id: 1,
    name: "greater than",
    isMultiSelect: false
  }, {
    id: 2,
    name: "lesser than",
    isMultiSelect: false
  }, {
    id: 3,
    name: "is not",
    isMultiSelect: false
  }, {
    id: 4,
    name: "contains any of",
    isMultiSelect: true
  }, {
    id: 5,
    name: "contains all of",
    isMultiSelect: true
  }, {
    id: 6,
    name: "does not contain",
    isMultiSelect: true
  }];

  $('#field-rules').on('cocoon:after-insert', function(e, containerDiv) {
    var customField = $(containerDiv).find(".custom-field select");
    listenCustomField(containerDiv, customField);
  });

  $('.field-rule').each(function() {
    var customField = $(this).find(".custom-field select");
    listenCustomField($(this), customField);
  });

  function listenCustomField(containerDiv, customField) {
    customField.on('change', function() {
      var selectedCustomField = $(customField).find(':selected');
      var type = selectedCustomField.data('type');
      var options = selectedCustomField.data('options');
      var operatorObjects = operators.filter(function(op) {
        return $.inArray(op.id, selectedCustomField.data('operators')) >= 0;
      });

      applyChangesOnOperatorField(containerDiv, operatorObjects, type, options);
    });
    customField.change();
  }

  function applyChangesOnOperatorField(containerDiv, operatorObjects, type, options) {
    var operatorContainer = $(containerDiv).find('.operator');
    var operatorField = operatorContainer.find('select');
    operatorField.find('option').remove();
    operatorObjects.forEach(function(op) {
      operatorField.append($('<option>', { value: op.id, text: op.name }));
      operatorField.val(operatorField.data('operator-id'));
    });
    listenOperatorField(containerDiv, operatorField, type, options);
    operatorContainer.show();
    operatorField.change();
  }

  function listenOperatorField(containerDiv, operatorField, type, options) {
    operatorField.on('change', function() {
      var selectedOperatorField = $(this).find(':selected');
      var selectedOperator;
      operators.forEach(function(op) {
        if(selectedOperatorField.val() == op.id){
          selectedOperator = op;
          return;
        }
      });
      applyChangesOnValueField(containerDiv, selectedOperator, type, options);
    });
  }

  function applyChangesOnValueField(containerDiv, selectedOperator, type, options){
    var valueContainer, valueField;
    if(type === 'SelectField' || type === 'CheckboxField'){
      containerDiv.find('.value-text input').attr('disabled','disabled').hide();
      valueContainer = containerDiv.find('.value-select');
      valueContainer.show();
      valueField = valueContainer.find('select');
    }
    else {
      containerDiv.find('.value-select select').attr('disabled','disabled').hide();
      valueContainer = containerDiv.find('.value-text');
      valueContainer.show();
      valueField = valueContainer.find('input');
    }

    if(selectedOperator && selectedOperator.isMultiSelect) {
      valueField.attr('multiple', 'multiple');
    }
    else {
      valueField.removeAttr('multiple');
    }

    var selectedValues = [];
    try {
      selectedValues = valueField.data('selected-values') || [];
    } catch(e) {
      selectedValues = [];
    }

    switch (type) {
      case 'SelectField':
        applyChangesOfSelectField(valueField, options, selectedValues);
        break;
      case 'CheckboxField':
        applyChangesOfSelectField(valueField, options, selectedValues);
        break;
      case 'DateField':
        valueField.attr('type', 'text');
        applyChangesOfTextField(valueField, selectedValues);
        initializeDatePicker(valueField, null, false);
        break;
      case 'NumericField':
        valueField.attr('type', 'number');
        applyChangesOfTextField(valueField, selectedValues);
        break;
      default:
        valueField.attr('type', 'text');
        applyChangesOfTextField(valueField, selectedValues);
        break;
    }
  }

  function applyChangesOfSelectField(valueField, options, selectedValues) {
    valueField.removeAttr('disabled').find('option').remove();
    options.forEach(function(item) {
      valueField.append($('<option>', { value: item, text: item }));
    });
    valueField.val(selectedValues);
    valueField.select2({ width: '100%' });
  }

  function applyChangesOfTextField(valueField, selectedValues) {
    valueField.removeAttr('disabled').val("");
    valueField.pikaday('destroy');
    if(valueField.attr('name') && valueField.attr('name').substr(-2) !== "[]") {
      valueField.attr('name', valueField.attr('name')+'[]');
    }
    valueField.val(selectedValues);
  }
});
