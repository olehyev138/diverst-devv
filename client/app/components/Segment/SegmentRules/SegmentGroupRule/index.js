/**
 *
 * SegmentGroupRule
 *
 */

import React from 'react';
import PropTypes from 'prop-types';

import { connect, Field, getIn } from 'formik';
import Select from 'components/Shared/DiverstSelect';
import { Grid } from '@material-ui/core';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Segment/messages';
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
      <Grid container spacing={3} alignItems='center'>
        <Grid item xs>
          <Select
            name={`${ruleLocation}.group_ids`}
            id={`${ruleLocation}.group_ids`}
            label={<DiverstFormattedMessage {...messages.rule.group.field} />}
            isMulti
            options={props.groups}
            value={groups}
            onMenuOpen={groupSelectAction}
            onChange={v => props.formik.setFieldValue(`${ruleLocation}.group_ids`, v)}
            onInputChange={value => groupSelectAction(value)}
            onBlur={() => props.formik.setFieldTouched('group_ids', true)}
          />
        </Grid>
        <Grid item xs>
          <Select
            name={`${ruleLocation}.operator`}
            id={`${ruleLocation}.operator`}
            label={<DiverstFormattedMessage {...messages.rule.group.operator} />}
            options={operators}
            value={{ value: operatorValue, label: operators[operatorValue].label }}
            onChange={v => props.formik.setFieldValue(`${ruleLocation}.operator`, v.value)}
          />
        </Grid>
      </Grid>
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
