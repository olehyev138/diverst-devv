/**
 *
 * Group Member Form Component
 *
 */

import React, {
  memo, useRef, useState, useEffect
} from 'react';
import { NavLink } from 'react-router-dom';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import {
  Button, Card, CardActions, CardContent, Grid,
  TextField, Hidden, FormControl
} from '@material-ui/core';
import Select from 'react-select';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { Field, Formik, Form } from 'formik';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { FormattedMessage } from 'react-intl';
import messages from 'containers/Group/messages';

import { buildValues, mapFields } from 'utils/formHelpers';

/* eslint-disable object-curly-newline */
export function GroupMemberFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  const usersSelectAction = (searchKey = '') => {
    props.getUsersBegin({
      count: 10, page: 0, order: 'asc',
      search: searchKey,
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
            label='New Members'
            isMulti
            value={values.member_ids}
            options={props.selectUsers}
            onMenuOpen={usersSelectAction}
            onChange={value => setFieldValue('member_ids', value)}
            onInputChange={value => usersSelectAction(value)}
            onBlur={() => setFieldTouched('member_ids', true)}
          />
        </CardContent>
        <CardActions>
          <Button
            color='primary'
            type='submit'
          >
            Add Members
          </Button>
          <Button
            to={ROUTES.admin.manage.groups.index.path()}
            component={WrappedNavLink}
          >
            <FormattedMessage {...messages.cancel} />
          </Button>
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

      render={formikProps => <GroupMemberFormInner {...props} {...formikProps} />}
    />
  );
}

GroupMemberForm.propTypes = {
  createMembersBegin: PropTypes.func,
  group: PropTypes.object,
  groupId: PropTypes.string
};

GroupMemberFormInner.propTypes = {
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  selectUsers: PropTypes.array,
  getUsersBegin: PropTypes.func,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func
};

export default compose(
  memo,
)(GroupMemberForm);
