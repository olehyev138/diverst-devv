/**
 *
 * Event Form Component
 *
 */

import React, { memo, useEffect, useMemo, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { DateTime } from 'luxon';

import { useLastLocation } from 'react-router-last-location';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { Field, Formik, Form, FastField } from 'formik';
import {
  Button, Card, CardActions, CardContent, TextField, Grid, Divider,
} from '@material-ui/core';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/Event/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

import DiverstDateTimePicker from 'components/Shared/Pickers/DiverstDateTimePicker';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstCancel from 'components/Shared/DiverstCancel';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import DiverstFileInput from 'components/Shared/DiverstFileInput';

import { getPillarsBegin } from 'containers/Group/Pillar/actions';
import { getBudgetItemsBegin } from 'containers/Group/GroupPlan/BudgetItem/actions';
import { createStructuredSelector } from 'reselect';
import { connect } from 'react-redux';
import { selectPaginatedSelectPillars } from 'containers/Group/Pillar/selectors';
import { selectPaginatedSelectBudgetItems } from 'containers/Group/GroupPlan/BudgetItem/selectors';
import DiverstSelect from 'components/Shared/DiverstSelect';
import { useInjectReducer } from 'utils/injectReducer';
import { useInjectSaga } from 'utils/injectSaga';
import pillarReducer from 'containers/Group/Pillar/reducer';
import pillarSaga from 'containers/Group/Pillar/saga';
import budgetItemReducer from 'containers/Group/GroupPlan/BudgetItem/reducer';
import budgetItemSaga from 'containers/Group/GroupPlan/BudgetItem/saga';
import { getCurrency } from 'utils/currencyHelpers';
import DiverstMoneyField from 'components/Shared/DiverstMoneyField';
import GroupSelector from 'components/Shared/GroupSelector';
import DiverstRichTextInput from 'components/Shared/DiverstRichTextInput';
import { selectPermissions, selectCustomText } from 'containers/Shared/App/selectors';
import { permission } from 'utils/permissionsHelpers';
import Permission from 'components/Shared/DiverstPermission';
import { injectIntl, intlShape } from 'react-intl';

/* eslint-disable object-curly-newline */
export function EventFormInner({ buttonText, formikProps, ...props }) {
  const { handleSubmit, handleChange, handleBlur, values, touched, errors, setFieldValue, setFieldTouched, setFieldError } = formikProps;

  useInjectReducer({ key: 'pillars', reducer: pillarReducer });
  useInjectSaga({ key: 'pillars', saga: pillarSaga });
  useInjectReducer({ key: 'budgetItems', reducer: budgetItemReducer });
  useInjectSaga({ key: 'budgetItems', saga: budgetItemSaga });

  const pillarSelectAction = (searchKey = '') => {
    props.getPillarsBegin({
      count: 10, page: 0, order: 'asc',
      search: searchKey,
      group_id: props.currentGroup.id,
      minimal: true,
    });
  };

  const budgetSelectAction = (searchKey = '') => {
    props.getBudgetItemsBegin({
      count: 10, page: 0, order: 'asc',
      search: searchKey,
      group_id: props.currentGroup.id,
      event_id: values.id,
      query_scopes: ['approved'],
      is_done: 'false'
    });
  };

  return (
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.event}>
      <Card>
        <Form>
          <CardContent>
            <FastField
              component={TextField}
              onChange={handleChange}
              disabled={props.isCommitting}
              required
              fullWidth
              id='name'
              name='name'
              margin='normal'
              label={<DiverstFormattedMessage {...messages.inputs.name} />}
              value={values.name}
            />
          </CardContent>
          <Divider />
          <CardContent>
            <FastField
              component={DiverstRichTextInput}
              required
              onChange={value => setFieldValue('description', value)}
              id='description'
              name='description'
              margin='normal'
              label={<DiverstFormattedMessage {...messages.inputs.description} />}
              value={values.description}
            />
          </CardContent>
          <Divider />
          <CardContent>
            <FastField
              component={TextField}
              onChange={handleChange}
              disabled={props.isCommitting}
              fullWidth
              id='location'
              name='location'
              margin='normal'
              label={<DiverstFormattedMessage {...messages.inputs.location} />}
              value={values.location}
            />
          </CardContent>
          <Divider />
          <CardContent>
            <Field
              component={DiverstSelect}
              fullWidth
              required
              id='pillar_id'
              name='pillar_id'
              label={<DiverstFormattedMessage {...messages.inputs.goal} />}
              margin='normal'
              disabled={props.isCommitting}
              value={values.pillar_id}
              options={props.pillars}
              onChange={value => setFieldValue('pillar_id', value)}
              onInputChange={value => pillarSelectAction(value)}
              onBlur={() => setFieldTouched('pillar_id', true)}
            />
          </CardContent>
          <Permission show={permission(props, 'groups_view')}>
            <Divider />
            <CardContent>
              <GroupSelector
                groupField='participating_group_ids'
                dialogSelector

                label={<DiverstFormattedMessage {...messages.inputs.participatingGroups} />}
                isMulti
                disabled={props.isCommitting}
                queryScopes={[['except_id', props?.currentGroup?.id]]}
                handleChange={handleChange}
                values={values}
                setFieldValue={setFieldValue}
              />
            </CardContent>
          </Permission>
          <Divider />
          <CardContent>
            <Grid
              container
              spacing={3}
              alignContent='center'
              alignItems='center'
            >
              <Grid item xs={12} md={6}>
                <Field
                  component={DiverstSelect}
                  fullWidth
                  required
                  id='budget_item_id'
                  name='budget_item_id'
                  label={<DiverstFormattedMessage {...messages.inputs.budgetName} />}
                  margin='normal'
                  disabled={props.isCommitting || values.finished_expenses}
                  value={values.budget_item_id}
                  options={[props.freeEvent, ...props.budgetItems]}
                  onChange={(value) => {
                    setFieldValue('budget_item_id', value);
                    setFieldValue('estimated_funding', value.available);
                  }}
                  onInputChange={value => budgetSelectAction(value)}
                  onBlur={() => setFieldTouched('budget_item_id', true)}
                />
              </Grid>
              <Grid item xs={12} md={6}>
                <DiverstMoneyField
                  label={<DiverstFormattedMessage {...messages.inputs.budgetAmount} />}
                  name='estimated_funding'
                  id='estimated_funding'
                  margin='dense'
                  fullWidth
                  disabled={props.isCommitting || values.finished_expenses}
                  value={values.estimated_funding}
                  onChange={value => setFieldValue('estimated_funding', value)}
                  currency={getCurrency(values.currency)}
                  max={values.budget_item_id.available}
                />
              </Grid>
            </Grid>
          </CardContent>
          <Divider />
          <CardContent>
            <Grid container spacing={6} justify='space-between'>
              <Grid item xs md={5}>
                <Field
                  component={DiverstDateTimePicker}
                  disabled={props.isCommitting}
                  required
                  keyboardMode
                  /* eslint-disable-next-line dot-notation */
                  maxDate={touched['end'] ? values['end'] : undefined}
                  maxDateMessage={<DiverstFormattedMessage {...messages.inputs.starterror} />}
                  fullWidth
                  id='start'
                  name='start'
                  margin='normal'
                  label={<DiverstFormattedMessage {...messages.inputs.start} />}
                />
              </Grid>
              <Grid item xs md={5}>
                <Field
                  component={DiverstDateTimePicker}
                  disabled={props.isCommitting}
                  required
                  keyboardMode
                  /* eslint-disable-next-line dot-notation */
                  minDate={touched['start'] ? values['start'] : undefined}
                  minDateMessage={<DiverstFormattedMessage {...messages.inputs.enderror} />}
                  fullWidth
                  id='end'
                  name='end'
                  margin='normal'
                  label={<DiverstFormattedMessage {...messages.inputs.end} />}
                />
              </Grid>
            </Grid>
          </CardContent>
          <Divider />
          <CardContent>
            <FastField
              component={DiverstFileInput}
              fileName={props.event && props.event.picture_file_name}
              disabled={props.isCommitting}
              fullWidth
              id='picture'
              name='picture'
              margin='normal'
              label={<DiverstFormattedMessage {...messages.inputs.picture} />}
              value={values.picture}
              fileType='image'
            />
          </CardContent>
          <Divider />
          <CardActions>
            <DiverstSubmit isCommitting={props.isCommitting}>
              <DiverstFormattedMessage {...buttonText} />
            </DiverstSubmit>
            <DiverstCancel
              redirectFallback={props.event ? props.links.eventShow : props.links.eventsIndex}
              disabled={props.isCommitting}
            >
              <DiverstFormattedMessage {...messages.cancel} />
            </DiverstCancel>
          </CardActions>
        </Form>
      </Card>
    </DiverstFormLoader>
  );
}

export function EventForm(props) {
  const event = props?.event;

  const freeEvent = { label: <DiverstFormattedMessage {...messages.createLabel} />, value: null, available: '0' };

  const initialValues = buildValues(event, {
    id: { default: '' },
    name: { default: '' },
    description: { default: '' },
    start: { default: null },
    end: { default: null },
    picture: { default: null },
    max_attendees: { default: '' },
    location: { default: '' },
    budget_item: { default: freeEvent, customKey: 'budget_item_id' },
    estimated_funding: { default: '' },
    currency: { default: props.currentGroup.annual_budget_currency },
    finished_expenses: { default: false },
    pillar: { default: props.pillar, customKey: 'pillar_id' },
    owner_id: { default: '' },
    participating_group: { default: [], customKey: 'participating_group_ids' },
    owner_group_id: { default: props.currentGroup.id }
  });
  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        const payload = mapFields(values, ['budget_item_id', 'pillar_id', 'participating_group_ids']);
        props.eventAction(payload);
      }}
    >
      {formikProps => <EventFormInner {...props} freeEvent={freeEvent} formikProps={formikProps} />}
    </Formik>
  );
}

EventForm.propTypes = {
  edit: PropTypes.bool,
  eventAction: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  pillar: PropTypes.object,
};

EventFormInner.propTypes = {
  edit: PropTypes.bool,
  event: PropTypes.object,
  buttonText: PropTypes.object,

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
  }),

  getPillarsBegin: PropTypes.func.isRequired,
  getBudgetItemsBegin: PropTypes.func.isRequired,
  currentGroup: PropTypes.object.isRequired,
  pillars: PropTypes.array.isRequired,
  budgetItems: PropTypes.array.isRequired,

  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  links: PropTypes.shape({
    eventsIndex: PropTypes.string,
    eventShow: PropTypes.string,
  }),
  intl: intlShape.isRequired,
  customTexts: PropTypes.object,
  freeEvent: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  pillars: selectPaginatedSelectPillars(),
  budgetItems: selectPaginatedSelectBudgetItems(),
  permissions: selectPermissions(),
  customTexts: selectCustomText(),
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
  injectIntl,
  memo,
)(EventForm);
