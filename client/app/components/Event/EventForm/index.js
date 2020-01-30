/**
 *
 * Event Form Component
 *
 */

import React, { memo, useEffect } from 'react';
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
import messages from 'containers/Event/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

import DiverstDateTimePicker from 'components/Shared/Pickers/DiverstDateTimePicker';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import DiverstFileInput from 'components/Shared/DiverstFileInput';

import { getPillarsBegin } from 'containers/Group/Pillar/actions';
import { getBudgetItemsBegin } from 'containers/Group/GroupPlan/BudgetItem/actions';
import { createStructuredSelector } from 'reselect';
import { connect } from 'react-redux';
import { selectPaginatedSelectPillars } from 'containers/Group/Pillar/selectors';
import { selectPaginatedSelectBudgetItems } from 'containers/Group/GroupPlan/BudgetItem/selectors';
import Select from 'components/Shared/DiverstSelect';
import { useInjectReducer } from 'utils/injectReducer';
import { useInjectSaga } from 'utils/injectSaga';
import pillarReducer from 'containers/Group/Pillar/reducer';
import pillarSaga from 'containers/Group/Pillar/saga';
import budgetItemReducer from 'containers/Group/GroupPlan/BudgetItem/reducer';
import budgetItemSaga from 'containers/Group/GroupPlan/BudgetItem/saga';

const freeEvent = { label: 'Create new free event ($0.00)', value: null, available: 0 };

/* eslint-disable object-curly-newline */
export function EventFormInner({
  handleSubmit, handleChange, handleBlur, values, touched, errors,
  buttonText, setFieldValue, setFieldTouched, setFieldError,
  ...props
}) {
  useInjectReducer({ key: 'pillars', reducer: pillarReducer });
  useInjectSaga({ key: 'pillars', saga: pillarSaga });
  useInjectReducer({ key: 'budgetItems', reducer: budgetItemReducer });
  useInjectSaga({ key: 'budgetItems', saga: budgetItemSaga });

  const pillarSelectAction = (searchKey = '') => {
    props.getPillarsBegin({
      count: 10, page: 0, order: 'asc',
      search: searchKey,
      group_id: props.currentGroup.id,
    });
  };

  const budgetSelectAction = (searchKey = '') => {
    props.getBudgetItemsBegin({
      count: 10, page: 0, order: 'asc',
      search: searchKey,
      group_id: props.currentGroup.id,
      query_scopes: ['approved']
    });
  };

  return (
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.event}>
      <Card>
        <Form>
          <CardContent>
            <Field
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
            <Field
              component={TextField}
              onChange={handleChange}
              disabled={props.isCommitting}
              fullWidth
              id='description'
              name='description'
              multiline
              rows={4}
              variant='outlined'
              margin='normal'
              label={<DiverstFormattedMessage {...messages.inputs.description} />}
              value={values.description}
            />
          </CardContent>
          <Divider />
          <CardContent>
            <Field
              component={Select}
              fullWidth
              required
              id='pillar_id'
              name='pillar_id'
              label='Choosing which #Goal# this event will participate in'
              margin='normal'
              disabled={props.isCommitting}
              value={values.pillar_id}
              options={props.pillars}
              onMenuOpen={pillarSelectAction}
              onChange={value => setFieldValue('pillar_id', value)}
              onInputChange={value => pillarSelectAction(value)}
              onBlur={() => setFieldTouched('pillar_id', true)}
            />
          </CardContent>
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
                  component={Select}
                  fullWidth
                  required
                  id='budget_item_id'
                  name='budget_item_id'
                  label='Attach a budget to the event.'
                  margin='normal'
                  disabled={props.isCommitting || values.finished_expenses}
                  value={values.budget_item_id}
                  options={[freeEvent, ...props.budgetItems]}
                  onMenuOpen={budgetSelectAction}
                  onChange={(value) => {
                    setFieldValue('budget_item_id', value);
                    setFieldValue('estimated_funding', value.available);
                  }}
                  onInputChange={value => budgetSelectAction(value)}
                  onBlur={() => setFieldTouched('budget_item_id', true)}
                />
              </Grid>
              <Grid item xs={12} md={6}>
                <TextField
                  fullWidth
                  margin='dense'
                  disabled={props.isCommitting || values.finished_expenses}
                  id='estimated_funding'
                  name='estimated_funding'
                  type='number'
                  onChange={handleChange}
                  value={values.estimated_funding}
                  label='Specify amount to deduct from budget'
                  inputProps={{ min: 0, max: values.budget_item_id.available, step: 1 }}
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
                  maxDateMessage='Start date cannot be after end date'
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
                  minDate={values['start']}
                  minDateMessage='End date cannot be before start date'
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
            <Field
              component={DiverstFileInput}
              fileName={props.event && props.event.picture_file_name}
              disabled={props.isCommitting}
              fullWidth
              id='picture'
              name='picture'
              margin='normal'
              label={<DiverstFormattedMessage {...messages.inputs.picture} />}
              value={values.picture}
            />
          </CardContent>
          <Divider />
          <CardActions>
            <DiverstSubmit isCommitting={props.isCommitting}>
              {buttonText}
            </DiverstSubmit>
            <Button
              to={props.event ? props.links.eventShow : props.links.eventsIndex}
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

let start = null;
let end = null;

export function EventForm(props) {
  const event = dig(props, 'event');

  useEffect(() => {
    start = DateTime.local().plus({ hour: 1 });
    end = DateTime.local().plus({ hour: 2 });
  }, []);

  const initialValues = buildValues(event, {
    id: { default: '' },
    name: { default: '' },
    description: { default: '' },
    start: { default: start },
    end: { default: end },
    picture: { default: null },
    max_attendees: { default: '' },
    location: { default: '' },
    annual_budget_id: { default: '' },
    budget_item: { default: freeEvent, customKey: 'budget_item_id' },
    estimated_funding: { default: 0 },
    finished_expenses: { default: false },
    pillar: { default: '', customKey: 'pillar_id' },
    owner_id: { default: '' },
    owner_group_id: { default: props.currentGroup.id }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        const payload = mapFields(values, ['budget_item_id', 'pillar_id']);
        props.eventAction(payload);
      }}
    >
      {formikProps => <EventFormInner {...props} {...formikProps} />}
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
};

EventFormInner.propTypes = {
  edit: PropTypes.bool,
  event: PropTypes.object,
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
    eventsIndex: PropTypes.string,
    eventShow: PropTypes.string,
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
)(EventForm);
