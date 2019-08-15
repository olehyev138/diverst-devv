/**
 *
 * SegmentFieldRule
 *
 */

import React from 'react';
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
  const { ruleName } = props;
  const { ruleIndex } = props;
  const ruleLocation = `${ruleName}.${ruleIndex}`;

  const field = getIn(props.formik.values, `${ruleLocation}.field_id`);
  const operatorValue = getIn(props.formik.values, `${ruleLocation}.operator`);
  let fieldOptions = [];

  const fieldSelectAction = (searchKey = '') => {
    props.getFieldsBegin({
      count: 10, page: 0, order: 'asc',
      search: searchKey,
    });
  };

  const onFieldSelectChange = (value) => {
    props.formik.setFieldValue(`${ruleLocation}.field_id`, value);

    const field = props.fields[value.value];
    fieldOptions = dig(field, 'options_text')
      ? field.options_text
        .split('\n')
        .map(option => ({ label: option, value: option }))
      : '';
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
            options={operators}
            value={{ value: operatorValue, label: operators[operatorValue].label }}
            onChange={v => props.formik.setFieldValue(`${ruleLocation}.operator`, v.value)}
          />
        </Grid>
        <Grid item xs={3}>
          <Select
            name={`${ruleLocation}.field_ids`}
            id={`${ruleLocation}.field_ids`}
            label='Options'
            options={fieldOptions}
            onMenuOpen={fieldSelectAction}
            onChange={v => props.formik.setFieldValue(`${ruleLocation}.field_ids`, v)}
            onInputChange={value => fieldSelectAction(value)}
            onBlur={() => props.formik.setFieldTouched('field_ids', true)}
          />
        </Grid>
      </Grid>
    </React.Fragment>
  );
};

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
