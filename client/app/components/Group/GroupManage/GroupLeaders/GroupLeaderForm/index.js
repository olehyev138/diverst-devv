/**
 *
 * Group Leader Form Component
 *
 */

import React, { memo, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';

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
  console.log(values);
  return (
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.groupLeader}>
      <Card>
        <Form>
          <CardContent>
            {Object.entries(values).map((i, _) => (
              // eslint-disable-next-line no-underscore-dangle
              !values[i]._destroy ? (
                <React.Fragment>
                  <Button
                    onCLick={setFieldValue(`[${i}]._destroy`, true)}
                  >
                    X
                  </Button>
                  <Field
                    component={Select}
                    fullWidth
                    id={`[${i}].user_ids`}
                    name={`[${i}].user_ids`}
                    label='Select User'
                    margin='normal'
                    disabled={props.isCommitting}
                    value={values.users}
                    options={props.selectUsers}
                    onMenuOpen={userSelectAction}
                    onChange={value => setFieldValue(`[${i}].user_ids`, value)}
                    onInputChange={value => userSelectAction(value)}
                    onBlur={() => setFieldTouched(`[${i}].user_ids`, true)}
                  />
                </React.Fragment>
              ) : <React.Fragment />
            ))}
          </CardContent>
          <Divider />
          <CardActions>
            <Button
              onClick={setFieldValue(`[${Object.keys(values).length}]`, props.baseValues)}
            >
              Add
            </Button>
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
// const baseValues = buildValues(props.groupLeader, {

export function GroupLeaderForm(props) {
  const baseValues = {
    // users: { default: [], customKey: 'member_ids' }
    id: { default: '' },
    _destroy: false,
    user_id: { default: '' },
    group_id: { default: props.groupId },
    position_name: { default: 'Group Leader' },
    user_role_id: { default: '4' },
    visible: true,
    pending_member_notifications_enabled: false,
    pending_comment_notifications_enabled: false,
    pending_posts_notifications_enabled: false,
    default_group_contact: false,
  };

  const leaders = dig(props, 'groupLeaders') || [];
  const leaderValues = leaders.map(leader => buildValues(leader, baseValues));
  const initialValues = Object.assign({}, leaderValues);

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.groupLeaderAction(mapFields(values, ['user_ids']));
      }}

      render={formikProps => <GroupLeaderFormInner {...props} {...formikProps} baseValues={baseValues} />}
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
  groupLeaders: PropTypes.array,
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
  baseValues: PropTypes.object,
  links: PropTypes.shape({
    groupLeadersIndex: PropTypes.string
  }),
};

export default compose(
  memo,
)(GroupLeaderForm);
