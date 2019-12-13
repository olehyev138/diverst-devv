// **
// *// *
// * Campaign Form Component
// *
// */

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
export function CampaignQuestionFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, touched, ...props }) {
  const { links } = props;

  return (
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.question}>
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
              label='* Start by giving a title to your question'
              placeholder='What do you think of our new strategy for...?'
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
              label='* Optionally define a description to further explain what you need resolution for'
              placeholder='We have been hammering at this problem for a very long time, and we need your input on how to...'
              value={values.description}
            />
          </CardContent>
          <Divider />

          <Divider />
          <CardActions>
            <DiverstSubmit isCommitting={props.isCommitting}>
              {buttonText}
            </DiverstSubmit>
            <Button
              disabled={props.isCommitting}
              to={links.questionsIndex}
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

export function CampaignQuestionForm(props) {
  const { campaignId } = props;
  const { questionId } = props;
  const initialValues = buildValues(props.question, {
    // users: { default: [], customKey: 'member_ids' }
    id: { default: '' },
    title: { default: '' },
    description: { default: '' },
    campaign_id: { default: campaignId },
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.questionAction(values);
      }}
    >
      {formikProps => <CampaignQuestionFormInner {...props} {...formikProps} />}
    </Formik>
  );
}
CampaignQuestionForm.propTypes = {
  edit: PropTypes.bool,
  createQuestionBegin: PropTypes.func,
  campaignId: PropTypes.string,
  questionId: PropTypes.string,
  isCommitting: PropTypes.bool,
  question: PropTypes.object,
  questionAction: PropTypes.func,
};

CampaignQuestionFormInner.propTypes = {
  edit: PropTypes.bool,
  question: PropTypes.object,
  createQuestionBegin: PropTypes.func,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  selectUsers: PropTypes.array,
  getQuestionBegin: PropTypes.func,
  // getMembersBegin: PropTypes.func,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  touched: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  links: PropTypes.shape({
    questionsIndex: PropTypes.string
  }),
};

export default compose(
  memo,
)(CampaignQuestionForm);
