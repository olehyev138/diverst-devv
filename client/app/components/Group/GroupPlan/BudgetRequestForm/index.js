/**
 *
 * Budget Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';
import { createStructuredSelector } from 'reselect';
import { connect } from 'react-redux';
import { useInjectSaga } from '../../../../utils/injectSaga';
import { useInjectReducer } from '../../../../utils/injectReducer';
import { DateTime } from 'luxon';
import { Field, FieldArray, Form, Formik } from 'formik';
import {
  Box,
  Button,
  CardContent,
  Divider,
  FormControl,
  FormControlLabel,
  Grid,
  IconButton,
  Paper,
  Switch,
  TextField,
  Typography
} from '@material-ui/core';
import DeleteIcon from '@material-ui/icons/DeleteOutline';
import { buildValues, mapFields } from 'utils/formHelpers';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import { DiverstDatePicker } from 'components/Shared/Pickers/DiverstDatePicker';
import Select from 'components/Shared/DiverstSelect';

import { selectPaginatedSelectUsers } from 'containers/User/selectors';
import { getUsersBegin } from 'containers/User/actions';
import reducer from 'containers/User/reducer';
import saga from 'containers/User/saga';
import WrappedNavLink from "components/Shared/WrappedNavLink";

// import messages from 'containers/Shared/Budget/messages';

export function BudgetItemFormInner({ formikProps, arrayHelpers, ...props }) {
  const { handleSubmit, handleChange, handleBlur, values, setFieldValue, setFieldTouched } = formikProps;
  const { remove, insert, push } = arrayHelpers;

  const removeIndex = id => (() => remove(id));
  const insertAtIndex = (id, obj) => (() => insert(id, obj));
  const pushObject = obj => (() => push(obj));

  return (
    <React.Fragment>
      <Paper>
        <CardContent>
          <Grid
            container
            spacing={2}
            alignContent='space-between'
          >
            <Grid item align='left' xs={6}>
              <Typography color='secondary' variant='body1' component='h2' align='left'>
                Specify list of events you plan to organize with this budget
              </Typography>
            </Grid>
            <Grid item align='right' xs={6}>
              <Button
                color='primary'
                onClick={pushObject({
                  title: '',
                  estimated_amount: 0,
                  estimated_date: DateTime.local(),
                  is_private: false,
                })}
              >
                + Add Event
              </Button>
            </Grid>
          </Grid>
        </CardContent>
        <Divider />
        {values.budget_items.map((budgetItem, index) => (
          // eslint-disable-next-line react/no-array-index-key
          <React.Fragment key={index}>
            <CardContent>
              <Grid
                container
                spacing={2}
                alignItems='center'
                alignContent='center'
                justify='center'
              >
                <Grid item md={6} xs={12}>
                  <TextField
                    autoFocus
                    fullWidth
                    margin='dense'
                    disabled={props.isCommitting}
                    id={`budget_items[${index}].title`}
                    name={`budget_items[${index}].title`}
                    type='text'
                    onChange={handleChange}
                    value={values.budget_items[index].title}
                    required
                    label='Title'
                  />
                </Grid>
                <Grid item md={2} xs={4}>
                  <TextField
                    fullWidth
                    margin='dense'
                    disabled={props.isCommitting}
                    id={`budget_items[${index}].estimated_amount`}
                    name={`budget_items[${index}].estimated_amount`}
                    type='number'
                    onChange={handleChange}
                    value={values.budget_items[index].estimated_amount}
                    label='Estimated Amount'
                  />
                </Grid>
                <Grid item md={2} xs={4}>
                  <Field
                    component={DiverstDatePicker}
                    keyboardMode
                    fullWidth
                    disabled={props.isCommitting}
                    id={`budget_items[${index}].estimated_date`}
                    name={`budget_items[${index}].estimated_date`}
                    margin='normal'
                    label='Estimated Date'
                  />
                </Grid>
                <Grid item md={1} xs={2}>
                  <FormControl
                    variant='outlined'
                  >
                    <FormControlLabel
                      labelPlacement='top'
                      checked={values.budget_items[index].private}
                      control={(
                        <Field
                          component={Switch}
                          color='primary'
                          onChange={handleChange}
                          disabled={props.isCommitting}
                          id={`budget_items[${index}].private`}
                          name={`budget_items[${index}].private`}
                          margin='normal'
                          checked={values.budget_items[index].private}
                          value={values.budget_items[index].private}
                        />
                      )}
                      label='Private'
                    />
                  </FormControl>
                </Grid>
                <Grid item md={1} xs={2} align='center'>
                  <IconButton
                    size='small'
                    onClick={removeIndex(index)}
                  >
                    <DeleteIcon />
                  </IconButton>
                </Grid>
              </Grid>
            </CardContent>
            <Divider />
          </React.Fragment>
        ))}
      </Paper>
    </React.Fragment>
  );
}

/* eslint-disable object-curly-newline */
export function BudgetFormInner({ formikProps, buttonText, ...props }) {
  const { handleSubmit, handleChange, handleBlur, values, setFieldValue, setFieldTouched } = formikProps;
  useInjectReducer({ key: 'users', reducer });
  useInjectSaga({ key: 'users', saga });

  const approverSelectAction = (searchKey = '') => {
    props.getUsersBegin({
      count: 10, page: 0, order: 'asc',
      search: searchKey,
      group_id: props.currentGroup.id,
      type: 'budget_approval',
    });
  };

  return (
    <React.Fragment>
      <Form>
        <Paper>
          <CardContent>
            <Typography color='secondary' variant='body1' component='h2'>
              Your request will be sent to the group financial manager for approval
            </Typography>
            <TextField
              autoFocus
              fullWidth
              required
              margin='dense'
              id='description'
              name='description'
              type='text'
              onChange={handleChange}
              value={values.description}
              label='Description'
            />
          </CardContent>
        </Paper>
        <Box mb={2} />
        <Paper>
          <CardContent>
            <Typography color='secondary' variant='body1' component='h2'>
              You may notify an approval manager for them to review and accept your budget request faster.
            </Typography>
            <Field
              component={Select}
              fullWidth
              name='approver_id'
              id='approver_id'
              label='Approver'
              margin='normal'
              disabled={props.isCommitting || !props.currentGroup}
              value={values.approver_id}
              options={Object.values(props.approvers)}
              onMenuOpen={approverSelectAction}
              onChange={value => setFieldValue('approver_id', value)}
              onInputChange={value => approverSelectAction(value)}
              onBlur={() => setFieldTouched('approver_id', true)}
            />
          </CardContent>
        </Paper>
        <Box mb={2} />
        <FieldArray
          name='budget_items'
          render={arrayHelpers => (
            <BudgetItemFormInner
              formikProps={formikProps}
              arrayHelpers={arrayHelpers}
            />
          )}
        />
        <Box mb={2} />
        <Grid container spacing={2}>
          <Grid item>
            <DiverstSubmit isCommitting={props.isCommitting} variant='contained'>
              {buttonText}
            </DiverstSubmit>
          </Grid>
          <Grid item>
            <Button
              component={WrappedNavLink}
              to={props.links.index}
              disabled={props.isCommitting}
              variant='contained'
            >
              Cancel
            </Button>
          </Grid>
        </Grid>
      </Form>
    </React.Fragment>
  );
}

export function BudgetForm(props) {
  const budget = dig(props, 'budget');

  const initialValues = buildValues(budget, {
    description: { default: '' },
    approver_id: { default: '' },
    budget_items: { default: [] },
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        const payload = mapFields(values, ['approver_id']);
        props.budgetAction({ path: props.links.index, annual_budget_id: props.annualBudgetId, ...payload });
      }}
    >
      {formikProps => <BudgetFormInner {...props} formikProps={formikProps} />}
    </Formik>
  );
}

BudgetForm.propTypes = {
  budgetAction: PropTypes.func.isRequired,
  annualBudgetId: PropTypes.number,
  isCommitting: PropTypes.bool,
  isFetching: PropTypes.bool,
  edit: PropTypes.bool,
  links: PropTypes.shape({
    index: PropTypes.string,
  }).isRequired
};

BudgetFormInner.propTypes = {
  budget: PropTypes.object,
  approvers: PropTypes.array,
  currentGroup: PropTypes.object,

  formikProps: PropTypes.object,

  buttonText: PropTypes.string.isRequired,

  isCommitting: PropTypes.bool,
  isFetching: PropTypes.bool,

  getUsersBegin: PropTypes.func,

  links: PropTypes.shape({
    index: PropTypes.string,
  })
};

BudgetItemFormInner.propTypes = {
  formikProps: PropTypes.object,
  arrayHelpers: PropTypes.object,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  approvers: selectPaginatedSelectUsers(),
});

const mapDispatchToProps = {
  getUsersBegin,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(BudgetForm);
