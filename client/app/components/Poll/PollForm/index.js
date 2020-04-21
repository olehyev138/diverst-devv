/**
 *
 * Poll Form Component
 *
 */

import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';
import { DateTime } from 'luxon';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { Field, Formik, Form } from 'formik';
import {
  Button, Card, CardActions, CardContent, TextField, Grid, Divider,
} from '@material-ui/core';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/Poll/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';

import { getPillarsBegin } from 'containers/Group/Pillar/actions';
import { getBudgetItemsBegin } from 'containers/Group/GroupPlan/BudgetItem/actions';
import { createStructuredSelector } from 'reselect';
import { connect } from 'react-redux';
import { selectPaginatedSelectPillars } from 'containers/Group/Pillar/selectors';
import { selectPaginatedSelectBudgetItems } from 'containers/Group/GroupPlan/BudgetItem/selectors';

const freePoll = { label: 'Create new free poll ($0.00)', value: null, available: 0 };

/* eslint-disable object-curly-newline */
export function PollFormInner({
  handleSubmit, handleChange, handleBlur, values, touched, errors,
  buttonText, setFieldValue, setFieldTouched, setFieldError,
  ...props
}) {
  return (
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.poll}>
      <Card>
        <Form>
          <CardContent>
            <Field
              component={TextField}
              onChange={handleChange}
              disabled={props.isCommitting}
              required
              fullWidth
              id='title'
              name='title'
              margin='normal'
              label={<DiverstFormattedMessage {...messages.form.title} />}
              value={values.name}
            />
          </CardContent>
          <Divider />
          <CardActions>
            <DiverstSubmit isCommitting={props.isCommitting}>
              {buttonText}
            </DiverstSubmit>
            <Button
              to={props.poll ? props.links.pollShow : props.links.pollsIndex}
              component={WrappedNavLink}
              disabled={props.isCommitting}
            >
              <DiverstFormattedMessage {...messages.cancel} />
            </Button>
          </CardActions>
        </Form>
      </Card>
    </DiverstFormLoader>
  );
}

export function PollForm(props) {
  const poll = dig(props, 'poll');

  const initialValues = buildValues(poll, {
    id: { default: '' },
    title: { default: '' },
  });
  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.pollAction(values);
      }}
    >
      {formikProps => <PollFormInner {...props} {...formikProps} />}
    </Formik>
  );
}

PollForm.propTypes = {
  edit: PropTypes.bool,
  pollAction: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

PollFormInner.propTypes = {
  edit: PropTypes.bool,
  poll: PropTypes.object,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  touched: PropTypes.object,
  errors: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  setFieldError: PropTypes.func,

  getPillarsBegin: PropTypes.func.isRequired,
  getBudgetItemsBegin: PropTypes.func.isRequired,
  currentGroup: PropTypes.object.isRequired,
  pillars: PropTypes.array.isRequired,
  budgetItems: PropTypes.array.isRequired,

  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  links: PropTypes.shape({
    pollsIndex: PropTypes.string,
    pollShow: PropTypes.string,
  })
};

const mapStateToProps = createStructuredSelector({
  pillars: selectPaginatedSelectPillars(),
  budgetItems: selectPaginatedSelectBudgetItems(),
});

const mapDispatchToProps = {
  getPillarsBegin,
  getBudgetItemsBegin,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(PollForm);
