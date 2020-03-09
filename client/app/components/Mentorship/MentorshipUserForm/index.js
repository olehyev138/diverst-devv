/**
 *
 * MentorshipUser Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';

import { FormattedMessage, injectIntl, intlShape } from 'react-intl';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { Field, Formik, Form } from 'formik';
import {
  Button, Card, CardActions, CardContent, TextField,
  Divider, Grid, FormControlLabel, Switch, FormControl
} from '@material-ui/core';
import Select from 'components/Shared/DiverstSelect';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/Mentorship/messages';
import userMessages from 'containers/User/messages';
import appMessages from 'containers/Shared/App/messages';
import { buildValues, mapFields } from 'utils/formHelpers';
import { withStyles } from '@material-ui/core/styles';
import MentorshipMenu from 'components/Mentorship/MentorshipMenu';

/* eslint-disable object-curly-newline */
export function MentorshipUserFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  const days = [...Array(7).keys()].map(day => ({ label: props.intl.formatMessage(appMessages.days_of_week[day]), value: day }));
  return (
    <React.Fragment>
      { props.user && props.userSession.id === props.user.id && (
        <Card>
          <Form>
            <CardContent>
              {/* Mentorship? */}
              <Grid container>
                <Grid item xs>
                  <FormControl
                    variant='outlined'
                    margin='normal'
                    fullWidth
                  >
                    <FormControlLabel
                      labelPlacement='top'
                      checked={values.mentor}
                      control={(
                        <Field
                          component={Switch}
                          color='primary'
                          onChange={handleChange}
                          id='mentor'
                          name='mentor'
                          margin='normal'
                          checked={values.mentor}
                          value={values.mentor}
                        />
                      )}
                      label={<DiverstFormattedMessage {...messages.form.mentor} />}
                    />
                  </FormControl>
                </Grid>
                <Grid item xs>
                  <FormControl
                    variant='outlined'
                    margin='normal'
                    fullWidth
                  >
                    <FormControlLabel
                      labelPlacement='top'
                      checked={values.mentee}
                      control={(
                        <Field
                          component={Switch}
                          color='primary'
                          onChange={handleChange}
                          id='mentee'
                          name='mentee'
                          margin='normal'
                          checked={values.mentee}
                          value={values.mentee}
                        />
                      )}
                      label={<DiverstFormattedMessage {...messages.form.mentee} />}
                    />
                  </FormControl>
                </Grid>
              </Grid>
              {/* Mentorship Accepting? */}
              <Grid container>
                <Grid item xs>
                  <FormControl
                    variant='outlined'
                    margin='normal'
                    fullWidth
                  >
                    <FormControlLabel
                      labelPlacement='top'
                      checked={values.accepting_mentor_requests}
                      control={(
                        <Field
                          component={Switch}
                          color='primary'
                          onChange={handleChange}
                          id='accepting_mentor_requests'
                          name='accepting_mentor_requests'
                          margin='normal'
                          checked={values.accepting_mentor_requests}
                          value={values.accepting_mentor_requests}
                        />
                      )}
                      label={<DiverstFormattedMessage {...messages.form.acceptMentorRequest} />}
                    />
                  </FormControl>
                </Grid>
                <Grid item xs>
                  <FormControl
                    variant='outlined'
                    margin='normal'
                    fullWidth
                  >
                    <FormControlLabel
                      labelPlacement='top'
                      checked={values.accepting_mentee_requests}
                      control={(
                        <Field
                          component={Switch}
                          color='primary'
                          onChange={handleChange}
                          id='accepting_mentee_requests'
                          name='accepting_mentee_requests'
                          margin='normal'
                          checked={values.accepting_mentee_requests}
                          value={values.accepting_mentee_requests}
                        />
                      )}
                      label={<DiverstFormattedMessage {...messages.form.acceptMenteeRequest} />}
                    />
                  </FormControl>
                </Grid>
              </Grid>
              {/* Availability? */}
              {/* <Field */}
              {/*  component={Select} */}
              {/*  fullWidth */}
              {/*  id={`availabilities[${0}].day` } */}
              {/*  name={`availabilities[${0}].day`} */}
              {/*  margin='normal' */}
              {/*  label='Sonic The Hedgehog' */}
              {/*  value={values.availabilities ? values.availabilities[0].day : null} */}
              {/*  options={days || []} */}
              {/*  onChange={value => setFieldValue(`availabilities[${0}].day`, value)} */}
              {/*  onBlur={() => setFieldTouched(`availabilities[${0}].day`, true)} */}
              {/* /> */}

              {/* Mentor Bio */}
              <Field
                component={TextField}
                onChange={handleChange}
                fullWidth
                margin='normal'
                multiline
                rows={4}
                variant='outlined'
                id='mentorship_description'
                name='mentorship_description'
                value={values.mentorship_description}
                label={<DiverstFormattedMessage {...messages.form.mentorDescription} />}
              />
              {/* Interest */}
              <Select
                name='mentoring_interest_ids'
                id='mentoring_interest_ids'
                isMulti
                fullWidth
                margin='normal'
                label={<DiverstFormattedMessage {...messages.form.interests} />}
                value={values.mentoring_interest_ids}
                options={props.interestOptions}
                onChange={value => setFieldValue('mentoring_interest_ids', value)}
              />
              {/* Types */}
              <Select
                name='mentoring_type_ids'
                id='mentoring_type_ids'
                isMulti
                fullWidth
                margin='normal'
                label={<DiverstFormattedMessage {...messages.form.types} />}
                value={values.mentoring_type_ids}
                options={props.typeOptions}
                onChange={value => setFieldValue('mentoring_type_ids', value)}
              />
            </CardContent>
            <CardActions>
              <Button
                color='primary'
                type='submit'
              >
                Submit
              </Button>
            </CardActions>
          </Form>
        </Card>
      )}
    </React.Fragment>
  );
}

export function MentorshipUserForm(props) {
  const user = dig(props, 'user');

  const initialValues = buildValues(user, {
    first_name: { default: '' },
    last_name: { default: '' },
    mentor: { default: false },
    mentee: { default: false },
    accepting_mentee_requests: { default: false },
    accepting_mentor_requests: { default: false },
    availabilities: { default: null },
    mentoring_interests: { default: [], customKey: 'mentoring_interest_ids' },
    mentoring_types: { default: [], customKey: 'mentoring_type_ids' },
    mentorship_description: { default: '' },
    id: { default: undefined }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        const payload = mapFields(values, ['mentoring_interest_ids', 'mentoring_type_ids']);
        props.userAction(payload);
      }}
    >
      {formikProps => <MentorshipUserFormInner {...props} {...formikProps} />}
    </Formik>
  );
}

MentorshipUserForm.propTypes = {
  userAction: PropTypes.func,
  user: PropTypes.object,
  currentMentorshipUser: PropTypes.object,
};

MentorshipUserFormInner.propTypes = {
  intl: intlShape.isRequired,
  user: PropTypes.object,
  userSession: PropTypes.shape({
    id: PropTypes.number
  }).isRequired,
  fieldData: PropTypes.array,
  updateFieldDataBegin: PropTypes.func,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  interestOptions: PropTypes.array,
  typeOptions: PropTypes.array,
  links: PropTypes.shape({
    usersIndex: PropTypes.string
  })
};

export default compose(
  memo,
  injectIntl,
)(MentorshipUserForm);
