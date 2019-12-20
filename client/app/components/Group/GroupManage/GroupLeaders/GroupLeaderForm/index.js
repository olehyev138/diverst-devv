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
  const membersSelectAction = (searchKey = '') => {
    props.getMembersBegin({
      count: 500, page: 0, order: 'asc',
      search: searchKey,
      group_id: props.groupId,
      query_scopes: ['active']
    });
  };

  const roleOptions = [
    { value: 4, label: 'Group Leader' },
    { value: 5, label: 'Group Treasurer' },
    { value: 6, label: 'Group Content Creator' }
  ];
  return (
    props.selectMembers && (
      <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.groupLeader}>
        <Card>
          <Form>
            <Divider />
            <CardContent>
              <Field
                component={Select}
                fullWidth
                id='user_id'
                name='user_id'
                label='Select Member'
                margin='normal'
                disabled={props.isCommitting}
                value={values.user_id}
                options={props.selectMembers}
                onMenuOpen={membersSelectAction}
                onChange={value => setFieldValue('user_id', value)}
                onInputChange={value => membersSelectAction(value)}
                onBlur={() => setFieldTouched('user_id', true)}
              />
            </CardContent>
            <Divider />
            <Divider />
            <CardContent>
              <Field
                component={Select}
                fullWidth
                id='user_role'
                name='user_role'
                label='Group Role'
                margin='normal'
                disabled={props.isCommitting}
                value={values.user_role}
                options={roleOptions}
                onChange={setFieldValue}
                // onInputChange={value => roleSelectAction(value)}
                onBlur={() => setFieldTouched}
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
    )
  );
}
export function GroupLeaderForm(props) {
  const initialValues = buildValues(props.groupLeader, {
    // users: { default: [], customKey: 'member_ids' }
    id: { default: '' },
    user: { default: '', customKey: 'user_id' },
    group_id: { default: props.groupId },
    position_name: { default: 'Group Leader' },
    user_role_id: { default: '4' },
    visible: { default: true },
    pending_member_notifications_enabled: { default: false },
    pending_comments_notifications_enabled: { default: false },
    pending_posts_notifications_enabled: { default: false },
    default_group_contact: { default: false },
  });
  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.groupLeaderAction(mapFields(values, ['user_id']));
      }}
      render={formikProps => <GroupLeaderFormInner {...props} {...formikProps} />}
    />
  );
}
GroupLeaderForm.propTypes = {
  edit: PropTypes.bool,
  getGroupLeaderBegin: PropTypes.func,
  createGroupLeaderBegin: PropTypes.func,
  updateGroupLeaderBegin: PropTypes.func,
  getMembersBegin: PropTypes.func,
  group: PropTypes.object,
  groupId: PropTypes.string,
  groupLeaderId: PropTypes.string,
  isCommitting: PropTypes.bool,
  groupLeaders: PropTypes.array,
  groupLeader: PropTypes.object,
  groupLeaderAction: PropTypes.func,
};

GroupLeaderFormInner.propTypes = {
  edit: PropTypes.bool,
  groupLeaders: PropTypes.array,
  getGroupLeaderBegin: PropTypes.func,
  createGroupLeaderBegin: PropTypes.func,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  groupLeader: PropTypes.object,
  groupId: PropTypes.string,
  buttonText: PropTypes.string,
  selectMembers: PropTypes.array,
  getMembersBegin: PropTypes.func,
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
