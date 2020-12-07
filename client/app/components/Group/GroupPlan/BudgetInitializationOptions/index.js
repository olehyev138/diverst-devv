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
  Grid, Button, Box, Card, CardContent, TextField, Checkbox, FormControlLabel
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Group/GroupPlan/AnnualBudget/messages';
import { permission } from 'utils/permissionsHelpers';
import { toCurrencyString } from 'utils/currencyHelpers';
import Permission from 'components/Shared/DiverstPermission';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import {Formik, Form, Field} from 'formik';
import Select from 'components/Shared/DiverstSelect';

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
    { label: 'Parent Groups Only', value: 'parent' },
    { label: 'Regional Budgets', value: 'region' },
    { label: 'Independent Budgets', value: 'all' },
  ], []);

  const yearOptions = useMemo(() => {
    const date = new Date();
    const currYear = date.getFullYear();
    const from0to10 = [...Array(10).keys()];
    const yearRange = from0to10.map(n => currYear + n - 2);
    return [{ label: 'Current Year', value: null }] + yearRange.map(year => ({ label: year, value: year }));
  }, []);

  const quarterOptions = useMemo(() => [{ label: 'Current Quarter', value: null }]
      + [...Array(4).keys()].map(a => ({ label: a + 1, value: a + 1 })), []);

  return (
    <Formik
      initialValues={{
        amount: 0,
        type: { label: 'Parent Groups Only', value: 'parent' },
        year: { label: 'Current Year', value: null },
        with_quarter: false,
        quarter: { label: 'Current Quarter', value: null },
      }}
      enableReinitialize
      onSubmit={(values, actions) => {
        const payload = {
          amount: values.amount,
          init_quarter: values.with_quarter,
          type: values.type.value,
          period_override: [
            values.year.value,
            values.with_quarter ? values.quarter.value : null
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
          <CardContent>
            <Form>
              <TextField
                id='amount'
                name='amount'
                type='number'
                fullWidth
                margin='normal'
                label={<DiverstFormattedMessage {...messages.min} />}
                value={values.amount}
                onChange={handleChange}
              />
              <Box mb={2} />
              <Select
                name='type'
                id='type'
                isMulti
                fullWidth
                margin='normal'
                label={<DiverstFormattedMessage {...messages.form.interests} />}
                value={values.type}
                options={budgetTypesOption}
                onChange={value => setFieldValue('type', value)}
              />
              <Box mb={2} />
              <Grid container>
                <Grid item xs={10}>
                  <Select
                    name='year'
                    id='year'
                    isMulti
                    fullWidth
                    margin='normal'
                    label={<DiverstFormattedMessage {...messages.form.interests} />}
                    value={values.year}
                    options={yearOptions}
                    onChange={value => setFieldValue('year', value)}
                  />
                </Grid>
                <Grid item xs={2}>
                  <FormControlLabel
                    control={(
                      <Field
                        component={Checkbox}
                        onChange={handleChange}
                        id='with_quarter'
                        name='with_quarter'
                        margin='normal'
                        label='with_quarter'
                        value={values.with_quarter}
                        checked={values.with_quarter}
                      />
                    )}
                    label='with_quarter'
                  />
                </Grid>
              </Grid>
              {values.with_quarter && (
                <React.Fragment>
                  <Box mb={2} />
                  <Select
                    name='quarter'
                    id='quarter'
                    isMulti
                    fullWidth
                    margin='normal'
                    label={<DiverstFormattedMessage {...messages.form.interests} />}
                    value={values.quarter}
                    options={quarterOptions}
                    onChange={value => setFieldValue('quarter', value)}
                  />
                </React.Fragment>
              )}
            </Form>
          </CardContent>
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
