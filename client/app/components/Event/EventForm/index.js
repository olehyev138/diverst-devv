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
import { Field, Formik, Form, FastField, FieldArray } from 'formik';
import {
  Button,
  Card,
  CardActions,
  CardContent,
  TextField,
  Grid,
  Divider,
  Paper,
  Typography,
  FormControl,
  FormControlLabel,
  Switch, IconButton,
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
import { BudgetItemFormInner } from 'components/Group/GroupPlan/BudgetRequestForm';
import AddIcon from '@material-ui/icons/Add';
import DeleteIcon from '@material-ui/icons/DeleteOutline';
import useArgumentRemembering from 'utils/customHooks/rememberArguments';

const freeEvent = { label: 'Create new free event ($0.00)', value: null, available: '0' };

export function BudgetUserFormInner({ formikProps, arrayHelpers, ...props }) {
  const { handleSubmit, handleChange, handleBlur, values, setFieldValue, setFieldTouched } = formikProps;
  const { remove, insert, push } = arrayHelpers;

  const removeIndex = id => (() => setFieldValue(`budget_users_attributes[${id}]._destroy`, true));
  const insertAtIndex = (id, obj) => (() => insert(id, obj));
  const pushObject = obj => (() => push(obj));

  const budgetSelectAction = useArgumentRemembering(props.budgetSelectAction);

  return (
    <React.Fragment>
      <CardContent>
        <Grid
          container
          spacing={2}
          alignContent='space-between'
        >
          <Grid item align='left' xs={6}>
            <Typography color='secondary' variant='body1' component='h2' align='left'>
              <DiverstFormattedMessage {...messages.inputs.addBudgets} />
            </Typography>
          </Grid>
          <Grid item align='right' xs={6}>
            <Button
              color='primary'
              startIcon={<AddIcon />}
              onClick={pushObject({
                id: '',
                budget_item_id: { label: '', value: null, available: 0 },
                estimated: 0,
              })}
            >
              <DiverstFormattedMessage {...messages.addBudget} />
            </Button>
          </Grid>
        </Grid>
      </CardContent>
      <Divider />
      {values.budget_users_attributes.map((budgetUser, index) => (
        // eslint-disable-next-line no-underscore-dangle
        budgetUser._destroy ? <React.Fragment />
          : (
        // eslint-disable-next-line react/no-array-index-key
            <React.Fragment key={index}>
              <CardContent>
                <Grid
                  container
                  spacing={3}
                  alignContent='center'
                  alignItems='center'
                >
                  <Grid item xs={12} md={5}>
                    <Field
                      component={DiverstSelect}
                      fullWidth
                      required
                      id='budget_item_id'
                      name='budget_item_id'
                      label={<DiverstFormattedMessage {...messages.inputs.selectBudget} />}
                      margin='normal'
                      disabled={props.isCommitting || budgetUser.finished_expenses}
                      value={budgetUser.budget_item_id}
                      options={props.budgetItems}
                      onChange={(value) => {
                        setFieldValue(`budget_users_attributes[${index}].budget_item_id`, value);
                        setFieldValue(`budget_users_attributes[${index}].estimated`, value.available);
                      }}
                      onInputChange={value => budgetSelectAction(value)}
                      onBlur={() => setFieldTouched(`budget_users_attributes[${index}].budget_item_id`, true)}
                    />
                  </Grid>
                  <Grid item xs={11} md={6}>
                    <DiverstMoneyField
                      label={<DiverstFormattedMessage {...messages.inputs.budgetAmount} />}
                      name='estimated'
                      id='estimated'
                      margin='dense'
                      fullWidth
                      disabled={props.isCommitting || budgetUser.finished_expenses}
                      value={budgetUser.estimated}
                      onChange={value => setFieldValue(`budget_users_attributes[${index}].estimated`, value)}
                      currency={getCurrency(budgetUser.currency)}
                      max={budgetUser.budget_item_id.available}
                    />
                  </Grid>
                  <Grid item xs={1} md={1}>
                    <IconButton
                      size='small'
                      onClick={removeIndex(index)}
                    >
                      <DeleteIcon />
                    </IconButton>
                  </Grid>
                </Grid>
              </CardContent>
            </React.Fragment>
          )
      ))}
    </React.Fragment>
  );
}

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
                dialogQueryScopes={[['replace_with_children', props?.currentGroup?.id]]}
                handleChange={handleChange}
                values={values}
                setFieldValue={setFieldValue}
              />
            </CardContent>
          </Permission>
          <Divider />
          <FieldArray
            name='budget_users_attributes'
            render={arrayHelpers => (
              <BudgetUserFormInner
                formikProps={formikProps}
                arrayHelpers={arrayHelpers}
                budgetSelectAction={budgetSelectAction}
                {...props}
              />
            )}
          />

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
    budget_users: { default: [], customKey: 'budget_users_attributes' },
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
        const payload = mapFields(values, ['pillar_id', 'participating_group_ids']);
        payload.budget_users_attributes = payload.budget_users_attributes.map(a => mapFields(a, ['budget_item_id']));
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

BudgetUserFormInner.propTypes = {
  formikProps: PropTypes.object,
  arrayHelpers: PropTypes.object,
  isCommitting: PropTypes.bool,
  annualBudget: PropTypes.object,
  ...EventFormInner.propTypes
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
