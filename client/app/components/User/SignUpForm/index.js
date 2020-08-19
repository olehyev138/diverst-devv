/**
 *
 * User Form Component
 *
 */

import React, { memo, useCallback, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { Field, Formik, Form, ErrorMessage, FastField } from 'formik';
import {
  Button, Card, CardActions, CardContent, TextField,
  Divider, CardHeader, Box, Typography, Checkbox, FormControlLabel, FormGroup
} from '@material-ui/core';

import Select from 'components/Shared/DiverstSelect';
import messages from 'containers/User/messages';
import appMessages from 'containers/Shared/App/messages';
import signUpMessages from 'containers/User/SignUpPage/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import FieldInputForm from 'components/Shared/Fields/FieldInputForm/Loadable';
import Scrollbar from 'components/Shared/Scrollbar';
import Container from '@material-ui/core/Container';
import Logo from 'components/Shared/Logo';
import LargeSponsorCard from 'components/Branding/Sponsor/SponsorCard/large';
import DiverstHTMLEmbedder from 'components/Shared/DiverstHTMLEmbedder';
import { serializeFieldDataWithFieldId } from 'utils/customFieldHelpers';
import { union, difference, intersection } from 'utils/arrayHelpers';
import GroupSelectorItem from 'components/Shared/GroupSelector/item';
import DoubleArrowIcon from '@material-ui/icons/DoubleArrow';
import DiverstDialog from 'components/Shared/DiverstDialog';
import SubgroupJoinForm from 'components/Group/GroupHome/SubgroupJoinForm';
import { injectIntl, intlShape } from 'react-intl';

const submitGenerator = (action, token) => (values, actions) => {
  const payload = mapFields(values, ['time_zone']);
  payload.field_data_attributes = serializeFieldDataWithFieldId(values.fieldData);
  payload.group_ids = Object.keys(payload.groupIds).filter(key => payload.groupIds[key]);
  delete payload.fieldData;
  delete payload.groupIds;
  action({ token, ...payload });
};

const submitButtonGenerator = (submitText, committing, disabled = false) => (
  <DiverstSubmit
    isCommitting={committing}
    disabled={disabled}
    size='large'
    variant='contained'
    wrapperStyle={{ width: '100%' }}
    fullWidth
    endIcon={<DoubleArrowIcon />}
  >
    {submitText}
  </DiverstSubmit>
);

const activateButtonGenerator = (submitText, onClick = () => null, committing = false, disabled = false) => (
  <Button
    disabled={committing || disabled}
    size='large'
    variant='contained'
    style={{ width: '100%' }}
    color='primary'
    fullWidth
    endIcon={<DoubleArrowIcon />}
    onClick={onClick}
  >
    {submitText}
  </Button>
);

const submitText = (
  <Typography variant='h6'>
    <DiverstFormattedMessage {...signUpMessages.activate} />
  </Typography>
);

/* eslint-disable object-curly-newline */
export function SignUpFormInner({ formikProps, buttonText, errors, ...props }) {
  const { handleSubmit, handleChange, handleBlur, values, setFieldValue, setFieldTouched, setSubmitting } = formikProps;
  const { user, groups, enterprise, ...rest } = props;

  const [expandedGroups, setExpandedGroups] = useState({});
  /* Store a expandedGroupsHash for each group, that tracks whether or not its children are expanded */
  if (props.groups && props.groups.length !== 0 && Object.keys(expandedGroups).length <= 0) {
    const initialExpandedGroups = {};

    /* Setup initial hash, with each group set to false - do it like this because of how React works with state */
    /* eslint-disable-next-line no-return-assign */
    props.groups.map((id, i) => initialExpandedGroups[id] = false);
    setExpandedGroups(initialExpandedGroups);
  }

  const isSelected = useCallback(
    group => values.groupIds[group.id],
    [values.groupIds],
  );
  const addGroup = useCallback(
    group => setFieldValue(`groupIds[${group.id}]`, true),
    [values.groupIds],
  );

  const removeGroup = useCallback(
    group => setFieldValue(`groupIds[${group.id}]`, undefined),
    [values.groupIds],
  );

  const [consentOpen, setConsent] = useState(false);

  return (
    <Scrollbar>
      <Container>
        <Box mb={6} />
        <Logo maxHeight='60px' />
        <Box mb={6} />
        { enterprise.sponsors.length > 0 && (
          <React.Fragment>
            <LargeSponsorCard
              sponsor={enterprise.sponsors[0]}
              single
              noAsync
            />
            <Box mb={2} />
          </React.Fragment>
        )}
        { dig(enterprise, 'privacy_statement') && (
          <React.Fragment>
            <Card>
              <CardHeader
                title={<DiverstFormattedMessage {...appMessages.custom_text.privacy_statement} />}
              />
              <CardContent>
                <DiverstHTMLEmbedder
                  html={enterprise.privacy_statement}
                />
              </CardContent>
            </Card>
            <Box mb={2} />
          </React.Fragment>
        )}
        <DiverstFormLoader isLoading={props.isLoading} isError={!props.user}>
          <Form>
            <Card>
              <CardContent>
                <FastField
                  component={TextField}
                  onChange={handleChange}
                  fullWidth
                  required
                  disabled
                  margin='normal'
                  id='email'
                  name='email'
                  value={values.email}
                  label={<DiverstFormattedMessage {...messages.email} />}
                  InputProps={{
                    readOnly: true,
                  }}
                />
                <FastField
                  component={TextField}
                  onChange={handleChange}
                  fullWidth
                  required
                  type='password'
                  autoComplete='new-password'
                  disabled={props.isCommitting}
                  margin='normal'
                  id='password'
                  name='password'
                  value={values.password}
                  label={<DiverstFormattedMessage {...signUpMessages.password} />}
                />
                <FastField
                  component={TextField}
                  onChange={handleChange}
                  fullWidth
                  required
                  type='password'
                  disabled={props.isCommitting}
                  margin='normal'
                  id='password_confirmation'
                  name='password_confirmation'
                  value={values.password_confirmation}
                  label={<DiverstFormattedMessage {...signUpMessages.passwordConfirmation} />}
                />
                <Box mb={1} />
                <Divider />
                <Box mb={1} />
                <FastField
                  component={TextField}
                  onChange={handleChange}
                  fullWidth
                  required
                  disabled={props.isCommitting}
                  margin='normal'
                  id='first_name'
                  name='first_name'
                  value={values.first_name}
                  label={<DiverstFormattedMessage {...messages.first_name} />}
                />
                <FastField
                  component={TextField}
                  onChange={handleChange}
                  fullWidth
                  required
                  disabled={props.isCommitting}
                  margin='normal'
                  id='last_name'
                  name='last_name'
                  value={values.last_name}
                  label={<DiverstFormattedMessage {...messages.last_name} />}
                />
                <FastField
                  component={TextField}
                  onChange={handleChange}
                  fullWidth
                  disabled={props.isCommitting}
                  margin='normal'
                  multiline
                  rows={4}
                  variant='outlined'
                  id='biography'
                  name='biography'
                  value={values.biography}
                  label={<DiverstFormattedMessage {...messages.biography} />}
                />
                <FastField
                  component={Select}
                  fullWidth
                  disabled={props.isCommitting}
                  id='time_zone'
                  name='time_zone'
                  margin='normal'
                  label={<DiverstFormattedMessage {...messages.time_zone} />}
                  value={values.time_zone}
                  options={dig(props, 'user', 'timezones') || []}
                  onChange={value => setFieldValue('time_zone', value)}
                  onBlur={() => setFieldTouched('time_zone', true)}
                />
              </CardContent>
            </Card>
            <Box mb={2} />
            <Card>
              <CardContent>
                <FieldInputForm
                  fieldData={dig(props, 'user', 'field_data') || []}
                  updateFieldDataBegin={props.updateFieldDataBegin}
                  isCommitting={props.isCommitting}
                  isFormLoading={props.isFormLoading}

                  admin={props.admin}
                  messages={messages}
                  formikProps={formikProps}
                />
              </CardContent>
            </Card>
            <Box mb={2} />
            <Card>
              <CardContent>
                <Typography variant='body1'>
                  <DiverstFormattedMessage {...signUpMessages.group_select} />
                </Typography>
                <Box mb={2} />
                {(props.groups || []).map(group => (
                  <GroupSelectorItem
                    key={group.id}
                    isSelected={isSelected}
                    addGroup={addGroup}
                    removeGroup={removeGroup}
                    group={group}
                    expandedGroups={expandedGroups}
                    setExpandedGroups={setExpandedGroups}
                    doubleClickWait={0}
                    large
                  />
                ))}
              </CardContent>
            </Card>
            <Box mb={2} />
            <Card>
              <CardActions>
                {enterprise.onboarding_consent_enabled
                  ? activateButtonGenerator(submitText, () => setConsent(true), props.isCommitting)
                  : submitButtonGenerator(submitText, props.isCommitting)
                }
              </CardActions>
            </Card>
            <DiverstDialog
              open={consentOpen}
              title={props.intl.formatMessage(signUpMessages.consentTitle)}
              handleNo={() => setConsent(false)}
              content={(
                <Scrollbar>
                  <CardContent>
                    <DiverstHTMLEmbedder
                      html={
                        enterprise.onboarding_consent_message || ''
                      }
                    />
                    <FormControlLabel
                      control={(
                        <Field
                          component={Checkbox}
                          onChange={handleChange}
                          id='__consent_accepted__'
                          name='__consent_accepted__'
                          margin='normal'
                          disabled={props.isCommitting}
                          label={<DiverstFormattedMessage {...signUpMessages.consentAccept} />}
                          /* eslint-disable-next-line no-underscore-dangle */
                          value={values.__consent_accepted__}
                          /* eslint-disable-next-line no-underscore-dangle */
                          checked={values.__consent_accepted__}
                        />
                      )}
                      label={<DiverstFormattedMessage {...signUpMessages.consentAccept} />}
                    />
                  </CardContent>
                  <CardActions>
                    {activateButtonGenerator(
                      submitText,
                      () => {
                        setSubmitting(true);
                        submitGenerator(props.submitAction, props.token)(values);
                        setSubmitting(false);
                      },
                      props.isCommitting,
                      // eslint-disable-next-line no-underscore-dangle
                      !values.__consent_accepted__ && enterprise.onboarding_consent_enabled
                    )}
                  </CardActions>
                </Scrollbar>
              )}
            />
          </Form>
        </DiverstFormLoader>
        <Box mb={4} />
      </Container>
    </Scrollbar>
  );
}

export function SignUpForm(props) {
  const user = dig(props, 'user');

  const initialValues = buildValues(user, {
    email: { default: '' },
    first_name: { default: '' },
    last_name: { default: '' },
    biography: { default: '' },
    time_zone: { default: '' },
    password: { default: '' },
    password_confirmation: { default: '' },
    field_data: { default: [], customKey: 'fieldData' },
    group_ids: { default: {}, customKey: 'groupIds' },
    __consent_accepted__: { default: false }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={submitGenerator(props.submitAction, props.token)}
    >
      {formikProps => (
        <SignUpFormInner
          {...props}
          formikProps={formikProps}
          errors={props.errors}
        />
      )}
    </Formik>
  );
}

SignUpForm.propTypes = {
  intl: intlShape,
  submitAction: PropTypes.func,
  user: PropTypes.object,
  groups: PropTypes.arrayOf(PropTypes.object),
  enterprise: PropTypes.object,
  isCommitting: PropTypes.bool,
  isLoading: PropTypes.bool,
  token: PropTypes.string,
  buttonText: PropTypes.string,
  errors: PropTypes.object,
  links: PropTypes.shape({
    usersIndex: PropTypes.string,
    usersPath: PropTypes.func,
  })
};

SignUpFormInner.propTypes = {
  ...SignUpForm.propTypes,
  formikProps: PropTypes.object,
  setFormGroupIds: PropTypes.func,
  formGroupIds: PropTypes.object,
};

export default compose(
  injectIntl,
  memo,
)(SignUpForm);
