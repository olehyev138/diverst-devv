/**
 *
 * Group Member Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import {
  Button, Card, CardActions, CardContent, Divider
} from '@material-ui/core';
import Select from 'components/Shared/DiverstSelect';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { Field, Formik, Form } from 'formik';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/GroupMembers/messages';

import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstCancel from 'components/Shared/DiverstCancel';

import { buildValues, mapFields } from 'utils/formHelpers';

/* eslint-disable object-curly-newline */
export function GroupMemberFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  const usersSelectAction = (searchKey = '') => {
    props.getUsersBegin({
      count: 10, page: 0, order: 'asc',
      search: searchKey,
      query_scopes: [['not_member_of_group', props.currentGroup.id]]
    });
  };


  return (
    <Card>
      <Form>
        <CardContent>
          <Field
            component={Select}
            fullWidth
            id='member_ids'
            name='member_ids'
            label={<DiverstFormattedMessage {...messages.newmembers} />}
            disabled={props.isCommitting}
            isMulti
            margin='normal'
            value={values.member_ids}
            options={props.selectUsers}
            onChange={value => setFieldValue('member_ids', value)}
            onInputChange={value => usersSelectAction(value)}
            onBlur={() => setFieldTouched('member_ids', true)}
          />
        </CardContent>
        <Divider />
        <CardActions>
          <DiverstSubmit isCommitting={props.isCommitting}>
            <DiverstFormattedMessage {...messages.create} />
          </DiverstSubmit>
          <DiverstCancel
            disabled={props.isCommitting}
            redirectFallback={props.links.groupMembersIndex}
          >
            <DiverstFormattedMessage {...messages.cancel} />
          </DiverstCancel>
        </CardActions>
      </Form>
    </Card>
  );
}

export function GroupMemberForm(props) {
  const initialValues = buildValues(undefined, {
    users: { default: [], customKey: 'member_ids' }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.createMembersBegin({
          groupId: props.groupId,
          attributes: mapFields(values, ['member_ids'])
        });
      }}
    >
      {formikProps => <GroupMemberFormInner {...props} {...formikProps} />}
    </Formik>
  );
}

GroupMemberForm.propTypes = {
  createMembersBegin: PropTypes.func,
  group: PropTypes.object,
  groupId: PropTypes.string,
  isCommitting: PropTypes.bool,
};

GroupMemberFormInner.propTypes = {
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  selectUsers: PropTypes.array,
  getUsersBegin: PropTypes.func,
  currentGroup: PropTypes.object,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  isCommitting: PropTypes.bool,
  links: PropTypes.shape({
    groupMembersIndex: PropTypes.string
  }),
};

export default compose(
  memo,
)(GroupMemberForm);
