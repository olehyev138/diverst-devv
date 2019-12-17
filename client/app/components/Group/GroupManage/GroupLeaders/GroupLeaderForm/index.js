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
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.groupLeaders}>
      <Card>
        <Form>
          <CardContent>
            {Object.entries(values).map(([i, _]) => (
              // eslint-disable-next-line no-underscore-dangle
              !values[i]._destroy ? (
                <React.Fragment key={i}>
                  <Button
                    onClick={() => setFieldValue(`[${i}]._destroy`, true)}
                  >
                    X
                  </Button>
                  <Field
                    component={Select}
                    fullWidth
                    id={`[${i}].user_id`}
                    name={`[${i}].user_id`}
                    label='Select User'
                    margin='normal'
                    disabled={props.isCommitting}
                    value={values[i].user}
                    options={props.selectUsers}
                    onMenuOpen={userSelectAction}
                    onChange={value => setFieldValue(`[${i}].user_id`, value)}
                    onInputChange={value => userSelectAction(value)}
                    onBlur={() => setFieldTouched(`[${i}].user_id`, true)}
                  />
                </React.Fragment>
              ) : <React.Fragment />
            ))}
          </CardContent>
          <Divider />
          <CardActions>
            <Button
              onClick={() => setFieldValue(`[${Object.keys(values).length}]`, buildValues(null, props.baseValues))}
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
// const baseValues = buildValues(props.groupLeaders, {

export function GroupLeaderForm(props) {
  const baseValues = {
    // users: { default: [], customKey: 'member_ids' }
    id: { default: '' },
    _destroy: { default: false },
    user: { default: '', customKey: 'user_id' },
    group_id: { default: props.groupId },
    position_name: { default: 'Group Leader' },
    user_role_id: { default: '4' },
    visible: { default: true },
    pending_member_notifications_enabled: { default: false },
    pending_comment_notifications_enabled: { default: false },
    pending_posts_notifications_enabled: { default: false },
    default_group_contact: { default: false },
  };

  const leaders = dig(props, 'groupLeaders') || [];
  const leaderValues = leaders.map(leader => buildValues(leader, baseValues));
  const initialValues = Object.assign({}, leaderValues);

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.groupLeadersAction(mapFields(values, ['user_ids']));
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
  groupLeadersAction: PropTypes.func,
};

GroupLeaderFormInner.propTypes = {
  edit: PropTypes.bool,
  groupLeaders: PropTypes.array,
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
