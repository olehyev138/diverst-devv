/**
 *
 * Budget Overview Form Component
 *
 */

import React, {
  memo, useRef, useState, useEffect
} from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import Select from 'components/Shared/DiverstSelect';
import { Field, Formik, Form, getIn } from 'formik';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { withStyles } from '@material-ui/core/styles';

import { floatRound, toNumber } from 'utils/floatRound';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

import messages from 'containers/Group/GroupPlan/AnnualBudget/messages';
import appMessages from 'containers/Shared/App/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

import {
  Button, Card, CardActions, CardContent, Grid, Paper,
  TextField, InputAdornment, Input, FormControl, InputLabel, Typography,
} from '@material-ui/core';

import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import { injectIntl, intlShape } from 'react-intl';
import { DiverstMoneyField } from 'components/Shared/DiverstMoneyField';
import { getCurrency } from 'utils/currencyHelpers';

const { form: formMessages } = messages;

const styles = theme => ({
  noBottomPadding: {
    paddingBottom: '0 !important',
  },
});

/* eslint-disable object-curly-newline */
export function AnnualBudgetFormInner(
  { classes, handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, intl, annualBudget, ...props }
) {
  return (
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !annualBudget}>
      <Card>
        <Form>
          <CardContent>
            <DiverstMoneyField
              label={intl.formatMessage(formMessages.amount)}
              type='number'
              name='amount'
              id='amount'
              margin='dense'
              fullWidth
              disabled={props.isCommitting}
              value={values.amount}
              onChange={value => setFieldValue('amount', value)}

              currencyForm
              currency={values.currency}
              currency_name='currency'
              currency_id='currency'
              onCurrencyChange={value => setFieldValue('currency', value)}
            />
          </CardContent>
          { annualBudget && (
            <CardContent>
              <Grid
                container
                justify='space-between'
                spacing={3}
                alignContent='stretch'
                alignItems='center'
              >
                <Grid item sm={6}>
                  <Typography color='primary' variant='h6' component='h2'>
                    <DiverstFormattedMessage {...formMessages.leftover} />
                  </Typography>
                </Grid>
                <Grid item sm={6}>
                  <Typography color='primary' variant='h6' component='h2'>
                    <DiverstFormattedMessage {...formMessages.approved} />
                  </Typography>
                </Grid>
              </Grid>
              <Grid
                container
                justify='space-between'
                spacing={3}
                alignContent='stretch'
                alignItems='center'
              >
                <Grid item sm={6}>
                  <Typography color='secondary' variant='body1' component='h3'>
                    {`$${floatRound(annualBudget.leftover, 2)}`}
                  </Typography>
                </Grid>
                <Grid item sm={6}>
                  <Typography color='secondary' variant='body1' component='h3'>
                    {`$${floatRound(annualBudget.approved, 2)}`}
                  </Typography>
                </Grid>
              </Grid>
            </CardContent>
          )}
          <CardActions>
            <DiverstSubmit isCommitting={props.isCommitting}>
              <DiverstFormattedMessage {...formMessages.setAnnualBudget} />
            </DiverstSubmit>
            <Button
              disabled={props.isCommitting}
              to={ROUTES.admin.plan.budgeting.index.path()}
              component={WrappedNavLink}
            >
              <DiverstFormattedMessage {...formMessages.cancel} />
            </Button>
          </CardActions>
        </Form>
      </Card>
    </DiverstFormLoader>
  );
}

export function AnnualBudgetForm(props) {
  const initialValues = buildValues(props.annualBudget, {
    id: { default: '' },
    amount: { default: '' },
    currency: { default: getCurrency('USD') }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.annualBudgetAction(values);
      }}
    >
      {formikProps => <AnnualBudgetFormInner {...props} {...formikProps} />}
    </Formik>
  );
}

AnnualBudgetForm.propTypes = {
  annualBudgetAction: PropTypes.func,
  group: PropTypes.object,
  annualBudget: PropTypes.object,
  enterpriseId: PropTypes.number,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

AnnualBudgetFormInner.propTypes = {
  intl: intlShape.isRequired,
  edit: PropTypes.bool,
  group: PropTypes.object,
  annualBudget: PropTypes.object,
  classes: PropTypes.object,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

export default compose(
  injectIntl,
  memo,
  withStyles(styles)
)(AnnualBudgetForm);
