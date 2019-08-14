/**
 *
 * SegmentGroupRule
 *
 */

import React from 'react';
import PropTypes from 'prop-types';

import { connect, Field, getIn } from 'formik';
import Select from 'react-select';
import { FormattedMessage } from 'react-intl';
import messages from 'containers/Group/messages';
import { CardContent } from '@material-ui/core';

/*
 * Define UI strings for each Group operator
 *  - Could define UI strings in backend as well
 */
const operators = [
  { value: 0, label: 'Join' },
  { value: 1, label: 'Intersect' },
];

const SegmentGroupRule = ({ rule, ...props }) => {
  const { ruleName } = props;
  const { ruleIndex } = props;
  const ruleLocation = `${ruleName}.${ruleIndex}`;

  const groups = getIn(props.formik.values, `${ruleLocation}.group_ids`);
  const operatorValue = getIn(props.formik.values, `${ruleLocation}.operator`);

  const groupSelectAction = (searchKey = '') => {
    props.getGroupsBegin({
      count: 10, page: 0, order: 'asc',
      search: searchKey,
    });
  };

  return (
    <React.Fragment>
      <Select
        name={`${ruleLocation}.group_ids`}
        id={`${ruleLocation}.group_ids`}
        label='Groups'
        isMulti
        options={props.groups}
        value={groups}
        onMenuOpen={groupSelectAction}
        onChange={v => props.formik.setFieldValue(`${ruleLocation}.group_ids`, v)}
        onInputChange={value => groupSelectAction(value)}
        onBlur={() => props.formik.setFieldTouched('group_ids', true)}
      />
      <Select
        name={`${ruleLocation}.operator`}
        id={`${ruleLocation}.operator`}
        label='Group Operator'
        options={operators}
        value={{ value: operatorValue, label: operators[operatorValue].label }}
        onChange={v => props.formik.setFieldValue(`${ruleLocation}.operator`, v.value)}
      />
    </React.Fragment>
  );
};

SegmentGroupRule.propTypes = {
  ruleName: PropTypes.string,
  ruleIndex: PropTypes.number,
  rule: PropTypes.object,
  getGroupsBegin: PropTypes.func,
  groups: PropTypes.array,
  formik: PropTypes.object
};

export default connect(SegmentGroupRule);
