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

import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import DiverstSubmit from 'components/Shared/DiverstSubmit';

import { buildValues, mapFields } from 'utils/formHelpers';
import { DateTime } from 'luxon';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Innovate/Campaign/CampaignQuestion/messages';

import { injectIntl, intlShape } from 'react-intl';

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
              value={values.title}
              label={<DiverstFormattedMessage {...messages.question.title} />}
              placeholder={props.intl.formatMessage(messages.question.title_placeholder)}
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
              value={values.description}
              label={<DiverstFormattedMessage {...messages.question.description} />}
              placeholder={props.intl.formatMessage(messages.question.description_placeholder)}
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
              <DiverstFormattedMessage {...messages.question.cancel} />
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
  intl: intlShape.isRequired,
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
  injectIntl,
)(CampaignQuestionForm);
