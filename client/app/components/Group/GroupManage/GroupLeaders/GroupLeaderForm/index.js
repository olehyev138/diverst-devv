/**
 *
 * Group Leader Form Component
 *
 */
import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import {
  FormControlLabel, Card, CardActions, CardContent, Divider, Grid, TextField, Checkbox, FormGroup
} from '@material-ui/core';
import Select from 'components/Shared/DiverstSelect';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { Field, Formik, Form } from 'formik';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/GroupManage/messages';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstCancel from '../../../../Shared/DiverstCancel';
import { buildValues, mapFields } from 'utils/formHelpers';
import { injectIntl, intlShape } from 'react-intl';


export function GroupLeaderFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, touched, ...props }) {
  const { links } = props;

  const membersSelectAction = (searchKey = '') => {
    props.getMembersBegin({
      count: 25, page: 0, order: 'asc',
      group_id: props.groupId,
      query_scopes: ['active', ['user_search', searchKey]]
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
              onInputChange={value => membersSelectAction(value)}
              onBlur={() => setFieldTouched('user_id', true)}
              isLoading={props.isLoadingMembers}
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
          <CardContent>
            <TextField
              fullWidth
              id='position_name'
              name='position_name'
              label={<DiverstFormattedMessage {...messages.leader.position} />}
              margin='normal'
              disabled={props.isCommitting}
              value={values.position_name}
              onChange={handleChange}
              onBlur={() => setFieldTouched('position_name', true)}
            />
          </CardContent>
          <Divider />
          <CardContent>
            <FormGroup>
              <FormControlLabel
                control={(
                  <Field
                    component={Checkbox}
                    onChange={handleChange}
                    id='pending_member_notifications_enabled'
                    name='pending_member_notifications_enabled'
                    margin='normal'
                    disabled={props.isCommitting}
                    label={<DiverstFormattedMessage {...messages.leader.pending_member_notifications_enabled} />}
                    value='pending_member_notifications_enabled'
                    checked={values.pending_member_notifications_enabled}
                    color='primary'
                  />
                )}
                label={<DiverstFormattedMessage {...messages.leader.pending_member_notifications_enabled} />}
              />
              <FormControlLabel
                control={(
                  <Field
                    component={Checkbox}
                    onChange={handleChange}
                    id='pending_posts_notifications_enabled'
                    name='pending_posts_notifications_enabled'
                    margin='normal'
                    disabled={props.isCommitting}
                    label={<DiverstFormattedMessage {...messages.leader.pending_posts_notifications_enabled} />}
                    value='pending_posts_notifications_enabled'
                    checked={values.pending_posts_notifications_enabled}
                    color='primary'
                  />
                )}
                label={<DiverstFormattedMessage {...messages.leader.pending_posts_notifications_enabled} />}
              />
              <FormControlLabel
                control={(
                  <Field
                    component={Checkbox}
                    onChange={handleChange}
                    id='pending_comments_notifications_enabled'
                    name='pending_comments_notifications_enabled'
                    margin='normal'
                    disabled={props.isCommitting}
                    label={<DiverstFormattedMessage {...messages.leader.pending_comments_notifications_enabled} />}
                    value='pending_comments_notifications_enabled'
                    checked={values.pending_comments_notifications_enabled}
                    color='primary'
                  />
                )}
                label={<DiverstFormattedMessage {...messages.leader.pending_comments_notifications_enabled} />}
              />
            </FormGroup>
          </CardContent>
          <Divider />
          <CardActions>
            <DiverstSubmit isCommitting={props.isCommitting}>
              <DiverstFormattedMessage {...buttonText} />
            </DiverstSubmit>
            <DiverstCancel
              disabled={props.isCommitting}
              redirectFallback={links.index}
            >
              <DiverstFormattedMessage {...messages.cancel} />
            </DiverstCancel>
          </CardActions>
        </Form>
      </Card>
    </DiverstFormLoader>
  );
}
export function GroupLeaderForm(props) {
  const { intl } = props;

  const initialValues = buildValues(props.groupLeader, {
    id: { default: '' },
    user: { default: '', customKey: 'user_id' },
    group_id: { default: props.groupId },
    position_name: { default: intl.formatMessage(messages.leader.position, props.customTexts) },
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
  intl: intlShape.isRequired,
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
  isLoadingMembers: PropTypes.bool,
  groupLeader: PropTypes.object,
  groupLeaderAction: PropTypes.func,
  customTexts: PropTypes.object,
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
  buttonText: PropTypes.object,
  selectMembers: PropTypes.array,
  getMembersBegin: PropTypes.func,
  userRoles: PropTypes.array,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  touched: PropTypes.object,
  isCommitting: PropTypes.bool,
  isLoadingMembers: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  links: PropTypes.shape({
    index: PropTypes.string
  }),
};
export default compose(
  injectIntl,
  memo,
)(GroupLeaderForm);
