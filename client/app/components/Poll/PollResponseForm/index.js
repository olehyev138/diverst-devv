/**
 *
 * User Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { Field, Formik, Form, ErrorMessage } from 'formik';
import {
  Button, Card, CardActions, CardContent, TextField, CardHeader,
  Divider, Typography, Box, FormControlLabel, Switch, FormControl
} from '@material-ui/core';

import Select from 'components/Shared/DiverstSelect';
import messages from 'containers/Poll/PollResponsePage/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import FieldInputForm from 'components/Shared/Fields/FieldInputForm/Loadable';
import Scrollbar from 'components/Shared/Scrollbar';
import Container from '@material-ui/core/Container';
import Logo from 'components/Shared/Logo';
import { serializeFieldDataWithFieldId } from 'utils/customFieldHelpers';
import { injectIntl, intlShape } from 'react-intl';

/* eslint-disable object-curly-newline */
export function PollResponseFormInner({ formikProps, buttonText, errors, ...props }) {
  const { handleSubmit, handleChange, handleBlur, values, setFieldValue, setFieldTouched } = formikProps;
  return (
    <Scrollbar>
      <Container>
        <React.Fragment>
          <Box mb={6} />
          <Logo maxHeight='60px' />
          <Box mb={6} />
          <Card>
            <CardHeader
              title={dig(props, 'response', 'poll', 'title')}
            />
            <CardContent>
              <Typography variant='h6' color='secondary'>
                {dig(props, 'response', 'poll', 'description')}
              </Typography>
            </CardContent>
          </Card>
          <Box mb={2} />
          <DiverstFormLoader isLoading={props.isLoading} isError={!props.response}>
            <Form>
              <Card>
                <FieldInputForm
                  fieldData={dig(props, 'response', 'field_data') || []}
                  isCommitting={props.isCommitting}
                  isFetching={props.isLoading}

                  messages={messages.fields}
                  formikProps={formikProps}
                />
                <Divider />
                <CardContent>
                  <FormControl
                    variant='outlined'
                  >
                    <FormControlLabel
                      labelPlacement='end'
                      checked={values.anonymous}
                      control={(
                        <Field
                          component={Switch}
                          color='primary'
                          onChange={handleChange}
                          disabled={props.isCommitting}
                          id='anonymous'
                          name='anonymous'
                          margin='normal'
                          checked={values.anonymous}
                          value={values.anonymous}
                        />
                      )}
                      label={<DiverstFormattedMessage {...messages.form.anonymous} />}
                    />
                  </FormControl>
                </CardContent>
                <Divider />
                <CardActions>
                  <DiverstSubmit isCommitting={props.isCommitting}>
                    {<DiverstFormattedMessage {...messages.form.submit} />}
                  </DiverstSubmit>
                </CardActions>
              </Card>
            </Form>
          </DiverstFormLoader>
          <Box mb={4} />
        </React.Fragment>
      </Container>
    </Scrollbar>
  );
}

export function PollResponseForm(props) {
  const user = dig(props, 'response');
  const { intl } = props;

  const initialValues = buildValues(user, {
    anonymous: { default: false },
    field_data: { default: [], customKey: 'fieldData' }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        // eslint-disable-next-line no-restricted-globals
        if (confirm(intl.formatMessage(messages.form.submitConfirmation))) {
          const payload = {
            anonymous: values.anonymous,
            field_data_attributes: serializeFieldDataWithFieldId(values.fieldData)
          };
          props.submitAction({ token: props.token, ...payload });
        }
      }}
    >
      {formikProps => <PollResponseFormInner {...props} formikProps={formikProps} errors={props.errors} />}
    </Formik>
  );
}

PollResponseForm.propTypes = {
  intl: intlShape.isRequired,
  submitAction: PropTypes.func,
  response: PropTypes.object,
  isCommitting: PropTypes.bool,
  isLoading: PropTypes.bool,
  token: PropTypes.string,
  errors: PropTypes.object,
};

PollResponseFormInner.propTypes = {
  formikProps: PropTypes.object,
  errors: PropTypes.object,
  response: PropTypes.object,
  buttonText: PropTypes.string,
  isCommitting: PropTypes.bool,
  isLoading: PropTypes.bool,
  links: PropTypes.shape({
    usersIndex: PropTypes.string,
    usersPath: PropTypes.func,
  })
};

export default compose(
  memo,
  injectIntl,
)(PollResponseForm);
