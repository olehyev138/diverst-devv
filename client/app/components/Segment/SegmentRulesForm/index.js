/**
 *
 * Segment Rules Form Component
 *
 */

import React, {
  memo, useRef, useState, useEffect
} from 'react';
import { compose } from 'redux';
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
  TextField, Hidden, FormControl
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

const styles = theme => ({
  ruleInput: {
    width: '100%',
  },
});


/* eslint-disable object-curly-newline */
export function SegmentRulesFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  console.log(values);

  const [rulePositions, setRulePositions] = useState({
    fieldRulePosition: 0,
    orderRulePosition: 0,
    segmentRulePosition: 0
  });

  return (
    <Card>
      <Form>
        <FieldArray
          name='field_rules'
          render={arrayHelpers => (
            <React.Fragment>
              <Grid container>
                <Grid item>
                  <Button
                    color='primary'
                    onClick={() => {
                      console.log('field rule');
                    }}
                  >
                    + Field Rule
                  </Button>
                </Grid>
                <Grid item>
                  <Button
                    color='primary'
                    onClick={() => { console.log('order rule'); }}
                  >
                    + Order Rule
                  </Button>
                </Grid>
                <Grid item>
                  <Button
                    color='primary'
                    onClick={() => { console.log('group rule'); }}
                  >
                    + Group Rule
                  </Button>
                </Grid>
              </Grid>
              <CardContent>
                { /* Field rules */ }
                <Grid>
                  {values.fieldRules.map((rule, i) => (
                    <Grid item key={rule.id} className={props.classes.ruleInput}>
                      {Object.entries(rule).length !== 0 && (
                        <p>{rule.id}</p>
                      )}
                    </Grid>
                  ))}
                </Grid>
                { /* Order rules */ }
                <Grid>
                  {[].map((rule, i) => (
                    <Grid item key={rule.id} className={props.classes.ruleInput}>
                      {Object.entries(rule).length !== 0 && (
                        <React.Fragment />
                      )}
                    </Grid>
                  ))}
                </Grid>
                { /* Group rules */ }
                <Grid container>
                  {[].map((fieldDatum, i) => (
                    <Grid item key={fieldDatum.id} className={props.classes.ruleInput}>
                      {Object.entries(fieldDatum).length !== 0 && (
                        <React.Fragment />
                      )}
                    </Grid>
                  ))}
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
