/**
 *
 * SegmentOrderRule
 *
 */

import React from 'react';
import PropTypes from 'prop-types';

import { connect, getIn } from 'formik';
import Select from 'react-select';

/*
 * Define UI strings for each order field
 *  - Could define UI strings in backend as well
 */
const fields = [
  { value: 0, label: 'Sign-in Count' },
  { value: 1, label: 'Reward Points' }
];

/*
 * Define UI strings for each order operator
 *  - Could define UI strings in backend as well
 */
const operators = [
  { value: 0, label: 'Ascending' },
  { value: 1, label: 'Descending' },
];

const SegmentOrderRule = ({ rule, ...props }) => {
  const { ruleName } = props;
  const { ruleIndex } = props;
  const ruleLocation = `${ruleName}.${ruleIndex}`;

  const fieldValue = getIn(props.formik.values, `${ruleLocation}.field`);
  const operatorValue = getIn(props.formik.values, `${ruleLocation}.operator`);

  return (
    <React.Fragment>
      <Select
        name={`${ruleLocation}.field`}
        id={`${ruleLocation}.field`}
        label='Order Field'
        options={fields}
        value={{ value: fieldValue, label: fields[fieldValue].label }}
        onChange={v => props.formik.setFieldValue(`${ruleLocation}.field`, v.value)}
      />
      <Select
        name={`${ruleLocation}.operator`}
        id={`${ruleLocation}.operator`}
        label='Order Operator'
        options={operators}
        value={{ value: operatorValue, label: operators[operatorValue].label }}
        onChange={v => props.formik.setFieldValue(`${ruleLocation}.operator`, v.value)}
      />
    </React.Fragment>
  );
};

SegmentOrderRule.propTypes = {
  ruleName: PropTypes.string,
  ruleIndex: PropTypes.number,
  rule: PropTypes.object,
  formik: PropTypes.object
};

export default connect(SegmentOrderRule);
