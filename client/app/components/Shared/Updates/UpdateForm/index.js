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
import { serializeFieldDataWithFieldId } from 'utils/customFieldHelpers';

/* eslint-disable object-curly-newline */
export function UpdateFormInner({ formikProps, buttonText, ...props }) {
  const { handleSubmit, handleChange, handleBlur, values, setFieldValue, setFieldTouched } = formikProps;
  return (
    <React.Fragment>
      <DiverstFormLoader isLoading={props.isFetching} isError={props.edit && !props.update}>
        <Form>
          <Card>
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
          </Card>
          <Box mb={2} />
          <Card>
            <FieldInputForm
              fieldData={dig(props, 'update', 'field_data') || []}
              updateFieldDataBegin={props.updateFieldDataBegin}
              isCommitting={props.isCommitting}
              isFetching={props.isFetching}

              messages={messages}
              formikProps={formikProps}

              join
              noCard
            />
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
          </Card>
        </Form>
      </DiverstFormLoader>
    </React.Fragment>
  );
}

export function UpdateForm(props) {
  const update = dig(props, 'update');

  const initialValues = buildValues(update, {
    report_date: { default: DateTime.local() },
    comments: { default: '' },
    id: { default: '' },
    field_data: { default: [], customKey: 'fieldData' }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        values.redirectPath = props.links.index;
        const payload = {
          ...values,
          field_data_attributes: serializeFieldDataWithFieldId(values.fieldData)
        };
        delete payload.fieldData;
        props.updateAction(payload);
      }}
    >
      {formikProps => <UpdateFormInner {...props} formikProps={formikProps} />}
    </Formik>
  );
}

UpdateForm.propTypes = {
  updateAction: PropTypes.func.isRequired,
  update: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFetching: PropTypes.bool,
  edit: PropTypes.bool,
  links: PropTypes.shape({
    index: PropTypes.string,
  }).isRequired
};

UpdateFormInner.propTypes = {
  update: PropTypes.object,
  fieldData: PropTypes.array,
  formikProps: PropTypes.object,
  updateFieldDataBegin: PropTypes.func.isRequired,
  buttonText: PropTypes.string.isRequired,
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
