/**
 *
 * Group Leader Form Component
 *
 */

import React, { memo, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import {
  Button, Card, CardActions, CardContent, Divider, Grid, TextField
} from '@material-ui/core';
import Select from 'components/Shared/DiverstSelect';
import DiverstDateTimePicker from 'components/Shared/Pickers/DiverstDateTimePicker';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { Field, Formik, Form } from 'formik';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import messages from 'containers/Group/GroupMembers/messages';
import DiverstSubmit from 'components/Shared/DiverstSubmit';

import { buildValues, mapFields } from 'utils/formHelpers';
import { DateTime } from 'luxon';

/* eslint-disable object-curly-newline */
export function GroupLeaderFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, touched, ...props }) {
  const { links } = props;
  const userSelectAction = (searchKey = '') => {
    props.getUsersBegin({
      count: 10, page: 0, order: 'asc',
      search: searchKey,
    });
  };

  // const getCampaignBeginAction = (searchKey = '') => {
  //   props.getCampaignBegin({
  //     count:
  //   })
  // }

  return (
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.groupLeader}>
      <Card>
        <Form>
          <CardContent>
            <Field
              component={TextField}
              required
              onChange={handleChange}
              fullWidth
              id='title'
              name='title'
              margin='normal'
              disabled={props.isCommitting}
              label='Campaign Title'
              value={values.title}
            />
            <Field
              component={TextField}
              onChange={handleChange}
              fullWidth
              id='description'
              name='description'
              multiline
              rows={4}
              variant='outlined'
              margin='normal'
              disabled={props.isCommitting}
              label='Description'
              value={values.description}
            />
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
                  label='Pick start date and time'
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
                  label='Pick end date and time'
                />
              </Grid>
            </Grid>
            <Divider />
          </CardContent>
          <Divider />
          <CardContent>
            <Field
              component={Select}
              fullWidth
              id='user_ids'
              name='user_ids'
              label='Select User'
              isMulti
              margin='normal'
              disabled={props.isCommitting}
              value={values.users}
              options={props.selectUsers}
              onMenuOpen={userSelectAction}
              onChange={value => setFieldValue('user_ids', value)}
              onInputChange={value => userSelectAction(value)}
              onBlur={() => setFieldTouched('user_ids', true)}
            />
          </CardContent>
          <Divider />
          <CardActions>
            <DiverstSubmit isCommitting={props.isCommitting}>
              {buttonText}
            </DiverstSubmit>
            <Button
              disabled={props.isCommitting}
              to={links.GroupLeadersIndex}
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

export function GroupLeaderForm(props) {

  const initialValues = buildValues(props.groupLeader, {
    // users: { default: [], customKey: 'member_ids' }
    id: { default: '' },
    user_id: { default: '' },
    group_id: { default: '' },
    description: { default: '' },
    users: { default: [], customKey: 'user_ids' },
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.groupLeaderAction(mapFields(values, ['user_ids']));
      }}

      render={formikProps => <GroupLeaderFormInner {...props} {...formikProps} />}
    />
  );
}

GroupLeaderForm.propTypes = {
  edit: PropTypes.bool,
  createGroupLeaderBegin: PropTypes.func,
  updateGroupLeaderBegin: PropTypes.func,
  group: PropTypes.object,
  groupId: PropTypes.string,
  isCommitting: PropTypes.bool,
  groupLeader: PropTypes.object,
  groupLeaderAction: PropTypes.func,
};

GroupLeaderFormInner.propTypes = {
  edit: PropTypes.bool,
  groupLeader: PropTypes.object,
  createGroupLeaderBegin: PropTypes.func,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  selectUsers: PropTypes.array,
  getUsersBegin: PropTypes.func,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  touched: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  links: PropTypes.shape({
    groupLeadersIndex: PropTypes.string
  }),
};

export default compose(
  memo,
)(GroupLeaderForm);
