/**
 *
 * SegmentFieldRule
 *
 */

import React, { useState } from 'react';
import PropTypes from 'prop-types';

import dig from 'object-dig';
import { connect, Field, getIn } from 'formik';
import Select from 'components/Shared/DiverstSelect';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Segment/messages';

import { Grid, TextField } from '@material-ui/core';
import CustomField from 'components/Shared/Fields/FieldInputs/Field';

import { deserializeOptionsText } from 'utils/customFieldHelpers';

/*
 * Define operator values & associated UI strings
 *  WARNING: - these ids MUST match the operators defined in the Field model in the backend
 *           - use hash as we should not depend on order
 */
const operators = {
  0: 'Equals',
  1: 'Greater then',
  2: 'Lesser then',
  3: 'Is not',
  4: 'Contains any of',
  5: 'Contains all of',
  6: 'Does not contain',
  7: 'Greater then or equal',
  8: 'Lesser then or equal',
  9: 'Equals any of',
  10: 'Does not equal any of',
  11: 'Is part of'
};

/*
 * SegmentFieldRule
 *   - filter users based on there custom field values - defined in User.field_data
 *   - render 2 selects & a values input:
 *      - field select
 *      - operator select
 *      - values input
 *
 *    - field select:
 *       - async select that fetches Field's - this is the custom Field to filter on, ie 'Nationality'
 *    - operator select
 *       - dynamically loaded & dependent on the value of field select
 *       - these are the operators specific to the field type & evaluate if a user follows a field or not
 *       - each field (fetched via field select) is serialized with an array of operator codes
 *     - values input
 *       - dynamically loaded & dependent on the value of field select
 *       - the type of input depends on the type of field (SelectField - multi select, NumericField - number input...)
 *
 */

const SegmentFieldRule = (props) => {
  // define location of rule in values & pull rule object out
  const ruleLocation = `${props.ruleName}.${props.ruleIndex}`;

  // pull out field object, operator
  const currentField = getIn(props.formik.values, `${ruleLocation}.field`);
  const currentOperator = getIn(props.formik.values, `${ruleLocation}.operator`);

  // build options array for possible operators for currentField
  const [currentFieldOperators, setCurrentFieldOperators] = useState(buildOperatorOptions(currentField));

  // callback to fetch fields from backend
  const fieldSelectAction = (searchKey = '') => {
    props.getFieldsBegin({
      fieldDefinerId: props.currentEnterprise.id,
      count: 10, page: 0, order: 'asc',
      orderBy: 'fields.id',
      search: searchKey,
    });
  };

  const onFieldSelectChange = (value) => {
    // wipe data & operator values
    props.formik.setFieldValue(`${ruleLocation}.data`, '');
    props.formik.setFieldValue(`${ruleLocation}.operator`, {});

    // fetch field object & deserialize options text for select
    const newField = props.fields[value.value];
    newField.options_text = deserializeOptionsText(newField);

    // Set new field object & id on rule
    props.formik.setFieldValue(`${ruleLocation}.field`, newField);
    props.formik.setFieldValue(`${ruleLocation}.field_id`, newField.id);

    // Build field options for new field
    setCurrentFieldOperators(buildOperatorOptions(newField));
  };

  return (
    <React.Fragment>
      <Grid container spacing={3} alignItems='center'>
        <Grid item xs>
          <Select
            name={`${ruleLocation}.field`}
            id={`${ruleLocation}.field`}
            label={<DiverstFormattedMessage {...messages.rule.field} />}
            options={props.selectFields}
            value={(currentField) ? { value: currentField.id, label: currentField.title } : {}}
            onChange={onFieldSelectChange}
            onInputChange={value => fieldSelectAction(value)}
          />
        </Grid>
        <Grid item xs>
          <Select
            name={`${ruleLocation}.operator`}
            id={`${ruleLocation}.operator`}
            label={<DiverstFormattedMessage {...messages.rule.operator} />}
            options={currentFieldOperators}
            value={{ value: currentOperator, label: operators[currentOperator] }}
            onChange={v => props.formik.setFieldValue(`${ruleLocation}.operator`, v.value)}
          />
        </Grid>
        <Grid item xs>
          <CustomField
            fieldDatum={getIn(props.formik.values, ruleLocation)}
            fieldDatumIndex={props.ruleIndex}
            dataLocation={`${ruleLocation}.data`}
          />
        </Grid>
      </Grid>
    </React.Fragment>
  );
};

const buildOperatorOptions = (field) => {
  if (!field) return [];
  return field.operators.map(op => ({ value: op, label: operators[op] }));
};

SegmentFieldRule.propTypes = {
  ruleName: PropTypes.string,
  ruleIndex: PropTypes.number,
  rule: PropTypes.object,
  getFieldsBegin: PropTypes.func,
  selectFields: PropTypes.array,
  fields: PropTypes.object,
  formik: PropTypes.object,
  currentEnterprise: PropTypes.shape({
    id: PropTypes.number,
  }).isRequired
};

export default connect(SegmentFieldRule);
