/**
 *
 * Group Leader Form Component
 *
 */
import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import {
  Button, Card, CardActions, CardContent, Divider, Grid, TextField
} from '@material-ui/core';
import Select from 'components/Shared/DiverstSelect';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { Field, Formik, Form } from 'formik';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/GroupManage/messages';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import { buildValues, mapFields } from 'utils/formHelpers';

export function GroupLeaderFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, touched, ...props }) {
  const { links } = props;

  const membersSelectAction = (searchKey = '') => {
    props.getMembersBegin({
      count: 25, page: 0, order: 'asc',
      search: searchKey,
      group_id: props.groupId,
      query_scopes: ['active']
    });
  };

  return (
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.groupLeader}>
      <Card>
        <Form>
          <CardContent>
            <Field
              component={Select}
              fullWidth
              id='user_id'
              name='user_id'
              label={<DiverstFormattedMessage {...messages.leader.select} />}
              margin='normal'
              disabled={props.isCommitting}
              value={values.user_id}
              options={props.selectMembers}
              onChange={value => setFieldValue('user_id', value)}
              onMenuOpen={() => membersSelectAction()}
              onKeyDown={membersSelectAction}
              onBlur={() => setFieldTouched('user_id', true)}
            />
          </CardContent>
          <Divider />
          <CardContent>
            <Field
              component={Select}
              fullWidth
              id='user_role_id'
              name='user_role_id'
              label={<DiverstFormattedMessage {...messages.leader.role} />}
              margin='normal'
              disabled={props.isCommitting}
              value={values.user_role_id}
              options={props.userRoles}
              onChange={value => setFieldValue('user_role_id', value)}
              onBlur={() => setFieldTouched('user_role_id', true)}
            />
          </CardContent>
          <Divider />
          <CardActions>
            <DiverstSubmit isCommitting={props.isCommitting}>
              {buttonText}
            </DiverstSubmit>
            <Button
              disabled={props.isCommitting}
              to={links.index}
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
    id: { default: '' },
    user: { default: '', customKey: 'user_id' },
    group_id: { default: props.groupId },
    position_name: { default: <DiverstFormattedMessage {...messages.leader.position} /> },
    user_role: { default: '', customKey: 'user_role_id' },
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
        props.groupLeaderAction(mapFields(values, ['user_id', 'user_role_id']));
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
  selectMembers: PropTypes.array,
  userRoles: PropTypes.array,
  group: PropTypes.object,
  groupId: PropTypes.string,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  groupLeader: PropTypes.object,
  groupLeaderAction: PropTypes.func,
};

GroupLeaderFormInner.propTypes = {
  edit: PropTypes.bool,
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
  userRoles: PropTypes.array,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  touched: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  links: PropTypes.shape({
    index: PropTypes.string
  }),
};
export default compose(
  memo,
)(GroupLeaderForm);
