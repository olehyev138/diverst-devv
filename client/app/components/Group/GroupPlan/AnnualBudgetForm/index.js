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

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

import messages from 'containers/Group/messages';
import appMessages from 'containers/Shared/App/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

import {
  Button, Card, CardActions, CardContent, Grid, Paper,
  TextField, InputAdornment, Input, Divider, Switch, FormControlLabel,
} from '@material-ui/core';

import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import { injectIntl, intlShape } from 'react-intl';

const styles = theme => ({
  noBottomPadding: {
    paddingBottom: '0 !important',
  },
});

/* eslint-disable object-curly-newline */
export function AnnualBudgetFormInner({ classes, handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, intl, ...props }) {
  return (
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.group}>
      <Card>
        <Form>
          <CardContent>
            <Input
              required
              onChange={handleChange}
              type='number'
              name='annual_budget'
              id='annual_budget'
              margin='dense'
              fullWidth
              disabled={props.isCommitting}
              label={<DiverstFormattedMessage {...messages.name} />}
              value={values.annual_budget}
              startAdornment={(
                <InputAdornment position={intl.formatMessage(appMessages.currency.placement)}>
                  {intl.formatMessage(appMessages.currency.defaultSymbol)}
                </InputAdornment>
              )}
            />
          </CardContent>
          <CardActions>
            <DiverstSubmit isCommitting={props.isCommitting}>
              <DiverstFormattedMessage {...messages.setAnnualBudget} />
            </DiverstSubmit>
            <Button
              disabled={props.isCommitting}
              to={ROUTES.admin.manage.groups.index.path()}
              component={WrappedNavLink}
            >
              <DiverstFormattedMessage {...messages.cancel} />
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
    annual_budget: { default: '' },
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
  groupId: PropTypes.string,
  enterpriseId: PropTypes.number,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  annualBudget: PropTypes.object,
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
