/**
 *
 * SegmentOrderRule
 *
 */

import React from 'react';
import PropTypes from 'prop-types';

import { connect, getIn } from 'formik';
import dig from 'object-dig';

import { Grid, TextField } from '@material-ui/core';

/*
 * Define UI strings for each order field number
 *  - Could define UI strings in backend as well
 */
const fields = Object.freeze({
  0: 'Sign-in Count',
  1: 'Reward Points',
});

/*
 * Define UI strings for each order field operator
 *  - Could define UI strings in backend as well
 */
const operators = Object.freeze({
  0: 'Ascending',
  1: 'Descending'
});

const SegmentOrderRule = ({ rule, ...props }) => {
  const { ruleName } = props;
  const { ruleIndex } = props;
  const ruleLocation = `${ruleName}.${ruleIndex}.id`;

  return (
    <TextField
      name={ruleLocation}
      id={ruleLocation}
      value={getIn(props.formik.values, ruleLocation)}
      onChange={props.formik.handleChange}
    />
  );
};

SegmentOrderRule.propTypes = {
  ruleName: PropTypes.string,
  ruleIndex: PropTypes.number,
  rule: PropTypes.object,
  formik: PropTypes.object
};

export default connect(SegmentOrderRule);
