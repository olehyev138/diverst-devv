/**
 *
 * AnnualBudgetList Component
 *
 *
 */

import React, {
  memo, useMemo
} from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import {
  Grid, Button, Box, Card, CardContent, TextField, Checkbox, FormControlLabel, CardActions,
  Typography } from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Group/GroupPlan/AnnualBudget/messages';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { Formik, Form, Field } from 'formik';
import Select from 'components/Shared/DiverstSelect';

import DiverstSubmit from 'components/Shared/DiverstSubmit';

const { adminList: listMessages } = messages;

const styles = theme => ({
  annualBudgetListItem: {
    width: '100%',
  },
  annualBudgetListItemDescription: {
    paddingTop: 8,
  },
  errorButton: {
    color: theme.palette.error.main,
  },
  buttons: {
    float: 'right',
  },
});

export function BudgetInitializationForm(props, context) {
  const { classes, intl } = props;

  const budgetTypesOption = useMemo(() => [
    { label: props.intl.formatMessage(messages.initializationForm.parentType, props.customText), value: 'parent' },
    { label: props.intl.formatMessage(messages.initializationForm.regionType, props.customText), value: 'region' },
    { label: props.intl.formatMessage(messages.initializationForm.allType, props.customText), value: 'all' },
  ], []);

  const yearOptions = useMemo(() => {
    const date = new Date();
    const currYear = date.getFullYear();
    const from0to10 = [...Array(10).keys()];
    const yearRange = from0to10.map(n => currYear + n - 2);
    return [
      { label: props.intl.formatMessage(messages.initializationForm.currentYear, props.customText), value: null }
    ].concat(
      yearRange.map(year => ({ label: year, value: year }))
    );
  }, []);

  const quarterOptions = useMemo(() => [
    { label: props.intl.formatMessage(messages.initializationForm.currentQuarter, props.customText), value: null }
  ].concat(
    [...Array(4).keys()].map(a => ({ label: a + 1, value: a + 1 }))
  ),
  []);

  return (
    <Formik
      initialValues={{
        amount: 0,
        type: { label: props.intl.formatMessage(messages.initializationForm.parentType, props.customText), value: 'parent' },
        year: { label: props.intl.formatMessage(messages.initializationForm.currentYear, props.customText), value: '' },
        with_quarter: false,
        quarter: { label: props.intl.formatMessage(messages.initializationForm.currentQuarter, props.customText), value: '' },
      }}
      enableReinitialize
      onSubmit={(values, actions) => {
        const payload = {
          amount: values.amount,
          init_quarter: values.with_quarter,
          type: values.type.value,
          period_override: [
            values.year.value || null,
            values.with_quarter ? values.quarter.value || null : null
          ]
        };
        props.resetAll(payload);
      }}
    >
      {({
        handleSubmit,
        handleChange,
        handleBlur,
        values,
        setFieldValue,
        setFieldTouched,
        ...otherFormikProps
      }) => (
        <Card>
          <Form>
            <CardContent>
              <Typography variant='h6'>
                <DiverstFormattedMessage {...messages.initializationForm.types} />
              </Typography>
              <ul>
                <li>
                  <Typography variant='body1'>
                    <DiverstFormattedMessage {...messages.initializationForm.parentType} />
                  </Typography>
                  <Typography variant='body2'>
                    <DiverstFormattedMessage {...messages.initializationForm.parentTypeExplanation} />
                  </Typography>
                </li>
                <li>
                  <Typography variant='body1'>
                    <DiverstFormattedMessage {...messages.initializationForm.regionType} />
                  </Typography>
                  <Typography variant='body2'>
                    <DiverstFormattedMessage {...messages.initializationForm.regionTypeExplanation} />
                  </Typography>
                </li>
                <li>
                  <Typography variant='body1'>
                    <DiverstFormattedMessage {...messages.initializationForm.allType} />
                  </Typography>
                  <Typography variant='body2'>
                    <DiverstFormattedMessage {...messages.initializationForm.allTypeExplanation} />
                  </Typography>
                </li>
              </ul>
              <Box mb={1} />
              <Select
                name='type'
                id='type'
                fullWidth
                margin='normal'
                label={<DiverstFormattedMessage {...messages.initializationForm.type} />}
                value={values.type}
                options={budgetTypesOption}
                onChange={value => setFieldValue('type', value)}
              />
              <Box mb={2} />
              <Grid container alignContent='space-between' alignItems='center' spacing={2}>
                <Grid item xs={10}>
                  <Select
                    name='year'
                    id='year'
                    fullWidth
                    margin='normal'
                    label={<DiverstFormattedMessage {...messages.initializationForm.year} />}
                    value={values.year}
                    options={yearOptions}
                    onChange={value => setFieldValue('year', value)}
                  />
                </Grid>
                <Grid item xs='auto'>
                  <FormControlLabel
                    control={(
                      <Field
                        component={Checkbox}
                        onChange={handleChange}
                        id='with_quarter'
                        name='with_quarter'
                        margin='normal'
                        label={<DiverstFormattedMessage {...messages.initializationForm.withQuarter} />}
                        value={values.with_quarter}
                        checked={values.with_quarter}
                      />
                    )}
                    label={<DiverstFormattedMessage {...messages.initializationForm.withQuarter} />}
                  />
                </Grid>
              </Grid>
              {values.with_quarter && (
                <React.Fragment>
                  <Box mb={2} />
                  <Select
                    name='quarter'
                    id='quarter'
                    fullWidth
                    margin='normal'
                    label={<DiverstFormattedMessage {...messages.initializationForm.quarter} />}
                    value={values.quarter}
                    options={quarterOptions}
                    onChange={value => setFieldValue('quarter', value)}
                  />
                </React.Fragment>
              )}
            </CardContent>
            <CardActions>
              <DiverstSubmit isCommitting={props.isCommitting}>
                <DiverstFormattedMessage {...messages.initializationForm.initialize} />
              </DiverstSubmit>
            </CardActions>
          </Form>
        </Card>
      )}
    </Formik>
  );
}

BudgetInitializationForm.propTypes = {
  intl: intlShape.isRequired,
  classes: PropTypes.object,
  resetAll: PropTypes.func,
  annualBudgetType: PropTypes.string,
  budgetPeriod: PropTypes.array,
  isCommitting: PropTypes.bool,
  customText: PropTypes.object,
  links: PropTypes.shape({
    annualBudgetNew: PropTypes.string,
    annualBudgetEdit: PropTypes.func
  })
};

export default compose(
  memo,
  withStyles(styles),
  injectIntl,
)(BudgetInitializationForm);
