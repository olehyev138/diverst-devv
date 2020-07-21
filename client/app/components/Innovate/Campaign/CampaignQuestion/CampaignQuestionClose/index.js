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
export function CampaignQuestionCloseInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, touched, ...props }) {
  const { links } = props;

  return (
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.question}>
      <Card>
        <Form>
          <CardContent>
            <h2>{props.intl.formatMessage(messages.question.mark_close)}</h2>
            <h4>{props.intl.formatMessage(messages.question.mark_close_description)}</h4>
            <Card>
              <CardContent>
                <Field
                  component={TextField}
                  onChange={handleChange}
                  fullWidth
                  id='conclusion'
                  name='conclusion'
                  margin='normal'
                  disabled={props.isCommitting}
                  placeholder={props.intl.formatMessage(messages.question.placeholder)}
                  value={values.conclusion}
                />
              </CardContent>
            </Card>
          </CardContent>
          <Divider />

          <Divider />
          <CardActions>
            <DiverstSubmit isCommitting={props.isCommitting}>
              <DiverstFormattedMessage {...messages.question.close} />
            </DiverstSubmit>
            <Button
              disabled={props.isCommitting}
              to={links.questionsIndex}
              component={WrappedNavLink}
            >
              <DiverstFormattedMessage {...messages.question.back} />
            </Button>
          </CardActions>
        </Form>
      </Card>
    </DiverstFormLoader>
  );
}

export function CampaignQuestionClose(props) {
  const { campaignId } = props;
  const { questionId } = props;
  const [defaultSolvedDate] = useState(DateTime.local());
  const initialValues = buildValues(props.question, {
    // users: { default: [], customKey: 'member_ids' }
    id: { default: '' },
    title: { default: '' },
    description: { default: '' },
    campaign_id: { default: campaignId },
    conclusion: { default: '' },
    solved_at: { default: defaultSolvedDate }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.questionAction(values);
      }}
      render={formikProps => <CampaignQuestionCloseInner {...props} {...formikProps} />}
    />
  );
}
CampaignQuestionClose.propTypes = {
  edit: PropTypes.bool,
  campaignId: PropTypes.string,
  questionId: PropTypes.string,
  isCommitting: PropTypes.bool,
  question: PropTypes.object,
  questionAction: PropTypes.func,
  getQuestionBegin: PropTypes.func,
  campaignQuestionsUnmount: PropTypes.func,
  isFormLoading: PropTypes.bool,
  users: PropTypes.array,
};

CampaignQuestionCloseInner.propTypes = {
  intl: intlShape.isRequired,
  edit: PropTypes.bool,
  question: PropTypes.object,
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
)(CampaignQuestionClose);
