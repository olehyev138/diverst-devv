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
  Typography, Switch
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Group/GroupPlan/AnnualBudget/messages';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { Formik, Form, Field } from 'formik';
import Select from 'components/Shared/DiverstSelect';

import DiverstSubmit from 'components/Shared/DiverstSubmit';
import { useBudgetFormatter } from 'utils/customHooks/budgetTitleFormatter';

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

  const { formatQuarter, formatYear, formatYearAndQuarter } = useBudgetFormatter(intl);

  const budgetTypesOption = useMemo(() => [
    { label: props.intl.formatMessage(messages.initializationForm.parentType, props.customTexts), value: 'parent' },
    { label: props.intl.formatMessage(messages.initializationForm.regionType, props.customTexts), value: 'region' },
    { label: props.intl.formatMessage(messages.initializationForm.allType, props.customTexts), value: 'all' },
  ], []);

  const yearOptions = useMemo(() => {
    const date = new Date();
    const currYear = date.getFullYear();
    const from0to10 = [...Array(10).keys()];
    const yearRange = from0to10.map(n => currYear + n);
    return [
      { label: props.intl.formatMessage(messages.initializationForm.currentYear, props.customTexts), value: null }
    ].concat(
      yearRange.map(year => ({ label: formatYear(year), value: year }))
    );
  }, [intl]);

  const quarterOptions = useMemo(() => [
    { label: props.intl.formatMessage(messages.initializationForm.currentQuarter, props.customTexts), value: null }
  ].concat(
    [...Array(4).keys()].map(a => ({ label: formatQuarter(a + 1), value: a + 1 }))
  ), [intl]);

  return (
    <Formik
      initialValues={{
        amount: 0,
        type: { label: props.intl.formatMessage(messages.initializationForm.parentType, props.customTexts), value: 'parent' },
        year: { label: props.intl.formatMessage(messages.initializationForm.currentYear, props.customTexts), value: '' },
        with_quarter: false,
        quarter: { label: props.intl.formatMessage(messages.initializationForm.currentQuarter, props.customTexts), value: '' },
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
              <FormControlLabel
                control={(
                  <Field
                    component={Switch}
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
  customTexts: PropTypes.object,
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
