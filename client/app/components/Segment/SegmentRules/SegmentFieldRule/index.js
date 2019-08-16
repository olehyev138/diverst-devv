/**
 *
 * SegmentFieldRule
 *
 */

import React, { useState } from 'react';
import PropTypes from 'prop-types';

import dig from 'object-dig';
import { connect, Field, getIn } from 'formik';
import Select from 'react-select';
import { FormattedMessage } from 'react-intl';
import messages from 'containers/Segment/messages';

import { Grid } from '@material-ui/core';

/*
 * Define operator values & associated UI strings
 *  WARNING: - this must be *exactly* the same as the one in models/segment_field_rule
 *           - ideally this should be pulled from the server
 */
const operators = [
  { value: 0, label: 'Equals' },
  { value: 1, label: 'Greater then' },
  { value: 2, label: 'Lesser then' },
  { value: 3, label: 'Is not' },
  { value: 4, label: 'Contains any of' },
  { value: 5, label: 'Contains all of' },
  { value: 6, label: 'Does not contain' },
  { value: 7, label: 'Greater then or equal' },
  { value: 8, label: 'Lesser then or equal' },
];

const SegmentFieldRule = ({ rule, ...props }) => {
  const [fieldOperators, setFieldOperators] = useState([]);
  const [fieldOptions, setFieldOptions] = useState([]);

  const ruleLocation = `${props.ruleName}.${props.ruleIndex}`;
  const field = getIn(props.formik.values, `${ruleLocation}.field_id`);
  const operatorValue = getIn(props.formik.values, `${ruleLocation}.operator`);

  /* Dispatch action to load fields */
  const fieldSelectAction = (searchKey = '') => {
    props.getFieldsBegin({
      count: 10, page: 0, order: 'asc',
      search: searchKey,
    });
  };

  /* Set new field & update options for field operator & option selects */
  const onFieldSelectChange = (value) => {
    props.formik.setFieldValue(`${ruleLocation}.field_id`, value);
    const field = props.fields[value.value];

    // set appropiate operators for newly selected field
    setFieldOperators(loadOperators(field));

    // deserialize field options & update state for newly selected field
    setFieldOptions(dig(field, 'options_text')
      ? field.options_text
        .split('\n')
        .map(option => ({ label: option, value: option }))
      : []);
  };

  return (
    <React.Fragment>
      <Grid container>
        <Grid item xs={3}>
          <Select
            name={`${ruleLocation}.field_ids`}
            id={`${ruleLocation}.field_ids`}
            label='Fields'
            options={props.selectFields}
            value={field}
            onMenuOpen={fieldSelectAction}
            onChange={onFieldSelectChange}
            onInputChange={value => fieldSelectAction(value)}
          />
        </Grid>
        <Grid item xs={3}>
          <Select
            name={`${ruleLocation}.operator`}
            id={`${ruleLocation}.operator`}
            label='Field Operator'
            options={fieldOperators}
            value={{ value: operatorValue, label: operators[operatorValue].label }}
            onChange={v => props.formik.setFieldValue(`${ruleLocation}.operator`, v.value)}
          />
        </Grid>
        <Grid item xs={3}>
          <Select
            name={`${ruleLocation}.values`}
            id={`${ruleLocation}.values`}
            label='Options'
            isMulti
            options={fieldOptions}
            onMenuOpen={fieldSelectAction}
            onChange={v => props.formik.setFieldValue(`${ruleLocation}.values`, v)}
            onInputChange={value => fieldSelectAction(value)}
            onBlur={() => props.formik.setFieldTouched('values', true)}
          />
        </Grid>
      </Grid>
    </React.Fragment>
  );
};

function loadOperators(field) {
  console.log(field);

  switch (field.type) {
    case 'SelectField':
      return [operators[0], operators[3]];
    case 'TextField':
      return [];
    case 'NumericField':
      return [];
    default:
      return [];
  }
}

SegmentFieldRule.propTypes = {
  ruleName: PropTypes.string,
  ruleIndex: PropTypes.number,
  rule: PropTypes.object,
  getFieldsBegin: PropTypes.func,
  selectFields: PropTypes.array,
  fields: PropTypes.object,
  formik: PropTypes.object
};

export default connect(SegmentFieldRule);
