/**
 *
 * Update Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';
import { DateTime } from 'luxon';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { Field, Formik, Form } from 'formik';
import {
  Button, Card, CardActions, CardContent, TextField,
  Divider, Typography, Box
} from '@material-ui/core';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { buildValues, mapFields } from 'utils/formHelpers';
import messages from 'containers/Shared/Update/messages';

import FieldInputForm from 'components/Shared/Fields/FieldInputForm/Loadable';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import { DiverstDatePicker } from 'components/Shared/Pickers/DiverstDatePicker';

/* eslint-disable object-curly-newline */
export function UpdateFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  console.log(values);
  return (
    <React.Fragment>
      <DiverstFormLoader isLoading={props.isFetching} isError={props.edit && !props.update}>
        <Card>
          <Form>
            <CardContent>
              <Field
                component={DiverstDatePicker}
                keyboardMode
                fullWidth
                id='report_date'
                name='report_date'
                margin='normal'
                label={<DiverstFormattedMessage {...messages.form.dateOfUpdate} />}
              />
              <Field
                component={TextField}
                onChange={handleChange}
                fullWidth
                disabled={props.isCommitting}
                margin='normal'
                id='comments'
                name='comments'
                value={values.comments}
                label={<DiverstFormattedMessage {...messages.form.comments} />}
              />
            </CardContent>
            <Divider />
            <CardActions>
              <DiverstSubmit isCommitting={props.isCommitting}>
                {buttonText}
              </DiverstSubmit>
              <Button
                disabled={props.isCommitting}
                to={props.links.index}
                component={WrappedNavLink}
              >
                <DiverstFormattedMessage {...messages.form.button.cancel} />
              </Button>
            </CardActions>
          </Form>
        </Card>
      </DiverstFormLoader>
      <Box mb={2} />
      <FieldInputForm
        fieldData={dig(props, 'update', 'field_data') || []}
        updateFieldDataBegin={props.updateFieldDataBegin}
        isCommitting={props.isCommitting}
        isFetching={props.isFetching}

        messages={messages}
      />
    </React.Fragment>
  );
}

export function UpdateForm(props) {
  const update = dig(props, 'update');

  if (update)
    console.log(update.field_data);

  const initialValues = buildValues(update, {
    report_date: {default: DateTime.local()},
    comments: {default: ''},
    id: {default: ''},
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        values.redirectPath = props.links.index;
        props.updateAction(values);
      }}
    >
      {formikProps => <UpdateFormInner {...props} {...formikProps} />}
    </Formik>
  );
}

UpdateForm.propTypes = {
  updateAction: PropTypes.func.isRequired,
  update: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFetching: PropTypes.bool,
  links: PropTypes.shape({
    index: PropTypes.string,
  }).isRequired
};

UpdateFormInner.propTypes = {
  update: PropTypes.object,
  fieldData: PropTypes.array,
  updateFieldDataBegin: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string.isRequired,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  admin: PropTypes.bool,
  edit: PropTypes.bool,
  isCommitting: PropTypes.bool,
  isFetching: PropTypes.bool,
  links: PropTypes.shape({
    index: PropTypes.string,
  })
};

export default compose(
  memo,
)(UpdateForm);
