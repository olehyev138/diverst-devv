/**
 *
 * Campaign Form Component
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

import { buildValues, mapFields } from 'utils/formHelpers';

/* eslint-disable object-curly-newline */
export function CampaignFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
//  const usersSelectAction = (searchKey = '') => {
//    props.getMembersBegin({
//      count: 10, page: 0, order: 'asc',
//      search: searchKey,
//    });
//  };
  /*
          <Field
            component={Select}
            fullWidth
            id='member_ids'
            name='member_ids'
            label='New Members'
            disabled={props.isCommitting}
            isMulti
            margin='normal'
            value={values.member_ids}
            options={props.selectUsers}
            onMenuOpen={usersSelectAction}
            onChange={value => setFieldValue('member_ids', value)}
            onInputChange={value => usersSelectAction(value)}
            onBlur={() => setFieldTouched('member_ids', true)}
          />
   */

  return (
    <Card>
      <Form>
        <CardContent>
        </CardContent>
        <Divider />
        <CardActions>
          <DiverstSubmit isCommitting={props.isCommitting}>
            <DiverstFormattedMessage {...messages.create} />
          </DiverstSubmit>
          <Button
            disabled={props.isCommitting}
            to={props.links.campaignIndex}
            component={WrappedNavLink}
          >
            <DiverstFormattedMessage {...messages.cancel} />
          </Button>
        </CardActions>
      </Form>
    </Card>
  );
}

export function CampaignForm(props) {
  const initialValues = buildValues(undefined, {
    // users: { default: [], customKey: 'member_ids' }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.createCampaignBegin({
          // attributes: mapFields(values, ['member_ids'])
        });
      }}

      render={formikProps => <CampaignFormInner {...props} {...formikProps} />}
    />
  );
}

CampaignForm.propTypes = {
  createCampaignBegin: PropTypes.func,
  group: PropTypes.object,
  groupId: PropTypes.string,
  isCommitting: PropTypes.bool,
};

CampaignFormInner.propTypes = {
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  selectUsers: PropTypes.array,
  // getMembersBegin: PropTypes.func,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  isCommitting: PropTypes.bool,
  links: PropTypes.shape({
    campaignIndex: PropTypes.string
  }),
};

export default compose(
  memo,
)(CampaignForm);
