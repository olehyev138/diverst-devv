/**
 *
 * Field Input Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { Formik, Form } from 'formik';

import { withStyles } from '@material-ui/styles';
import {
  Card, CardActions, Divider,
} from '@material-ui/core';

import { buildValues } from 'utils/formHelpers';

import { serializeFieldData } from 'utils/customFieldHelpers';

import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import FieldInputForm from 'components/Shared/Fields/FieldInputForm';

const styles = theme => ({
  fieldInput: {
    width: '100%',
  },
});

/* eslint-disable-next-line object-curly-newline */
export function FieldInputFormInner({ formikProps, messages, ...props }) {
  const { isFormLoading, edit, fieldData } = props;

  const submitButton = (
    <React.Fragment>
      <Divider />
      <CardActions>
        <DiverstSubmit isCommitting={props.isCommitting}>
          <DiverstFormattedMessage {...messages.fields_save} />
        </DiverstSubmit>
      </CardActions>
    </React.Fragment>
  );

  const cardWrapper = component => (
    <Card>
      {component}
    </Card>
  );

  const formWrapper = component => (
    <Form>
      {component}
    </Form>
  );

  const loaderWrapper = component => (
    <DiverstFormLoader isLoading={isFormLoading} isError={edit && !fieldData}>
      {component}
    </DiverstFormLoader>
  );

  return loaderWrapper(
    cardWrapper(
      formWrapper(
        <React.Fragment>
          <FieldInputForm
            formikProps={formikProps}
            messages={messages}
            {...props}
          />
          {submitButton}
        </React.Fragment>
      )
    )
  );
}

export function UserFieldInputForm(props) {
  const initialValues = buildValues({ fieldData: props.fieldData }, {
    fieldData: { default: [] },
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.updateFieldDataBegin({
          field_data: serializeFieldData(values.fieldData)
        });
      }}
    >
      {formikProps => <FieldInputFormInner formikProps={formikProps} {...props} />}
    </Formik>
  );
}

UserFieldInputForm.propTypes = {
  edit: PropTypes.bool,
  updateFieldDataBegin: PropTypes.func,
  fieldData: PropTypes.array,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,

  formikProps: PropTypes.bool,
  join: PropTypes.bool,
};

FieldInputFormInner.propTypes = {
  edit: PropTypes.bool,
  fieldData: PropTypes.array,
  formikProps: PropTypes.object,
  classes: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,

  join: PropTypes.bool,
  messages: PropTypes.shape({
    fields: PropTypes.shape({
      id: PropTypes.string
    }),
    preface: PropTypes.shape({
      id: PropTypes.string
    }),
    fields_save: PropTypes.shape({
      id: PropTypes.string
    }),
  }).isRequired
};

export default compose(
  memo,
  withStyles(styles),
)(UserFieldInputForm);
