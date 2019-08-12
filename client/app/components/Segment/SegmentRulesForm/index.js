/**
 *
 * Segment Rules Form Component
 *
 */

import React, {
  memo, useRef, useState, useEffect
} from 'react';
import { compose } from 'redux';
import dig from 'object-dig';

import PropTypes from 'prop-types';
import Select from 'react-select';
import {Field, Formik, Form, FieldArray} from 'formik';
import { FormattedMessage } from 'react-intl';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

import messages from 'containers/Segment/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

import {
  Button, Card, CardActions, CardContent, Grid,
  Paper, Tab, Tabs, TextField, Hidden, FormControl
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import SegmentRule from 'components/Segment/SegmentRules/SegmentRule';

const styles = theme => ({
  ruleInput: {
    width: '100%',
  },
});

const RuleTypes = Object.freeze({
  field: 0,
  order: 1,
  group: 2,
});


/* eslint-disable object-curly-newline */
export function SegmentRulesFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  /*
   *  - Tab for each 'rule type'
   *  - Define a 'ruleData' object for each type - including where to find it in values & a label
   *  - On tab change, swap out 'ruleData' object
   */
  const [tab, setTab] = useState(RuleTypes.field);
  const ruleData = [
    { name: 'fieldRules', label: '+ Field Rule', rules: values.fieldRules },
    { name: 'orderRules', label: '+ Order Rule', rules: values.orderRules },
    { name: 'groupRules', label: '+ Group Rule', rules: values.groupRules },
  ];

  const initialRules = [
    { field_id: 0, operator: 0, values: [] },
    { field: 0, operator: 0 },
    { id: 0 }
  ];

  const handleChangeTab = (event, newTab) => {
    setTab(newTab);
  };

  return (
    <Card>
      <Form>
        <Paper>
          <Tabs
            value={tab}
            onChange={handleChangeTab}
            indicatorColor='primary'
            textColor='primary'
            centered
          >
            <Tab label='Field Rules' />
            <Tab label='Order Rules' />
            <Tab label='Group Rules' />
          </Tabs>
        </Paper>
        <FieldArray
          name={ruleData[tab].name}
          render={arrayHelpers => (
            <React.Fragment>
              <CardContent>
                <Grid container>
                  {ruleData[tab].rules.map((rule, i) => (
                    /* eslint-disable-next-line react/no-array-index-key */
                    <Grid item key={i} className={props.classes.ruleInput}>
                      <SegmentRule ruleName={ruleData[tab].name} ruleIndex={i} />
                      <Button onClick={() => arrayHelpers.remove(i)}>X</Button>
                    </Grid>
                  ))}
                  <Button onClick={() => arrayHelpers.push(initialRules[tab])}>
                    {ruleData[tab].label}
                  </Button>
                </Grid>
              </CardContent>
            </React.Fragment>
          )}
        />
        <CardActions>
          <Button
            color='primary'
            type='submit'
          >
            Save
          </Button>
        </CardActions>
      </Form>
    </Card>
  );
}

export function SegmentRulesForm(props) {
  const initialValues = buildValues(props.rules, {
    fieldRules: { default: [] },
    orderRules: { default: [] },
    groupRules: { default: [] }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.segmentAction(values);
      }}

      render={formikProps => <SegmentRulesFormInner {...props} {...formikProps} />}
    />
  );
}

SegmentRulesForm.propTypes = {
  segmentAction: PropTypes.func,
  rules: PropTypes.object,
};

SegmentRulesFormInner.propTypes = {
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  classes: PropTypes.object
};

export default compose(
  memo,
  withStyles(styles)
)(SegmentRulesForm);
