/**
 *
 * Campaign Form Component
 *
 */

import React, { memo } from 'react';
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
import messages from 'containers/Group/GroupMembers/messages';
import DiverstSubmit from 'components/Shared/DiverstSubmit';

import { buildValues, mapFields } from 'utils/formHelpers';
import {DateTime} from "luxon";

/* eslint-disable object-curly-newline */
export function CampaignFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, touched, ...props }) {
  return (
    <Card>
      <Form>
        <CardContent>
          <Field
            component={TextField}
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
        <CardActions>
          <DiverstSubmit isCommitting={props.isCommitting}>
            {buttonText}
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
};

export function CampaignForm(props) {
  const initialValues = buildValues(undefined, {
    // users: { default: [], customKey: 'member_ids' }
    id: { default: '' },
    title: { default: '' },
    description: { default: '' },
    // start: { default: DateTime.local().plus({ hour: 1 }) },
    // end: { default: DateTime.local().plus({ hour: 2 }) },
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.createCampaignBegin(values);
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
