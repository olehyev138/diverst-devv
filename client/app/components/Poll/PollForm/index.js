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
  Button, Card, CardActions, CardContent, TextField, Grid, Divider, Box, CardHeader, Typography
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
import GroupSelector from 'components/Shared/GroupSelector';
import SegmentSelector from 'components/Shared/SegmentSelector';
import { FieldsSubForm } from 'components/Shared/Fields/FieldsSubForm';

/* eslint-disable object-curly-newline */
export function PollFormInner({ formikProps, buttonText, draftButtonText, header, poll, ...props }) {
  const { handleSubmit, handleChange, handleBlur, values, touched, errors,
    setFieldValue, setFieldTouched, setFieldError, setSubmitting } = formikProps;

  return (
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !poll}>
      <Form>
        <Card>
          <CardContent>
            <Typography variant='h5' color='primary'>
              {header}
            </Typography>
            <TextField
              onChange={handleChange}
              disabled={props.isCommitting}
              required
              fullWidth
              id='title'
              name='title'
              margin='normal'
              label={<DiverstFormattedMessage {...messages.form.title} />}
              value={values.title}
            />
            <TextField
              onChange={handleChange}
              disabled={props.isCommitting}
              required
              fullWidth
              multiline
              rows={4}
              variant='outlined'
              id='description'
              name='description'
              margin='normal'
              label={<DiverstFormattedMessage {...messages.form.description} />}
              value={values.description}
            />
            <Box mb={1} />
            <Divider />
            <GroupSelector
              groupField='group_ids'
              dialogSelector
              label={<DiverstFormattedMessage {...messages.form.groups} />}
              isMulti
              {...formikProps}
            />
            <SegmentSelector
              segmentField='segment_ids'
              label={<DiverstFormattedMessage {...messages.form.segments} />}
              isMulti
              {...formikProps}
            />
          </CardContent>
        </Card>
        <Box mb={1} />
        <Card>
          <CardContent>
            <FieldsSubForm
              formikProps={formikProps}
              fieldsName='fields_attributes'
              textField
              selectField
              checkboxField
              dateField
              numberField
            />
          </CardContent>
        </Card>
        <Box mb={1} />
        <Card>
          <CardActions>
            <DiverstSubmit isCommitting={props.isCommitting}>
              {buttonText}
            </DiverstSubmit>
            {dig(poll, 'status') === 'published' || (
              <Button
                to={props.poll ? props.links.pollShow : props.links.pollsIndex}
                component={WrappedNavLink}
                disabled={props.isCommitting}
              >
                {draftButtonText}
              </Button>
            )}
            <Button
              to={props.poll ? props.links.pollShow : props.links.pollsIndex}
              component={WrappedNavLink}
              disabled={props.isCommitting}
            >
              <DiverstFormattedMessage {...messages.cancel} />
            </Button>
          </CardActions>
        </Card>
      </Form>
    </DiverstFormLoader>
  );
}

export function PollForm(props) {
  const poll = dig(props, 'poll');

  const initialValues = buildValues(poll, {
    id: { default: '' },
    title: { default: '' },
    description: { default: '' },
    fields: { default: [], customKey: 'fields_attributes' },
    groups: { default: [], customKey: 'group_ids' },
    segments: { default: [], customKey: 'segment_ids' },
  });
  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.pollActionPublish(mapFields(values, ['group_ids', 'segment_ids']));
      }}
    >
      {formikProps => <PollFormInner {...props} formikProps={formikProps} />}
    </Formik>
  );
}

PollForm.propTypes = {
  edit: PropTypes.bool,
  pollAction: PropTypes.func,
  pollActionPublish: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

PollFormInner.propTypes = {
  edit: PropTypes.bool,
  poll: PropTypes.object,
  pollAction: PropTypes.func,
  formikProps: PropTypes.shape({
    handleSubmit: PropTypes.func,
    handleChange: PropTypes.func,
    handleBlur: PropTypes.func,
    values: PropTypes.object,
    touched: PropTypes.object,
    errors: PropTypes.object,
    setFieldValue: PropTypes.func,
    setFieldTouched: PropTypes.func,
    setFieldError: PropTypes.func,
    setSubmitting: PropTypes.func,
  }),
  header: PropTypes.oneOfType([PropTypes.string, PropTypes.element]),
  buttonText: PropTypes.oneOfType([PropTypes.string, PropTypes.element]),
  draftButtonText: PropTypes.oneOfType([PropTypes.string, PropTypes.element]),
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
