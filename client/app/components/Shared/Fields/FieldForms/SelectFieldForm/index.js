/**
 *
 *  SelectField Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { Field, Formik, Form } from 'formik';
import {
  Button, Card, CardActions, CardContent, TextField, Divider, Box
} from '@material-ui/core';


import messages from 'containers/Shared/Field/messages';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import { Toggles } from 'components/Shared/Fields/FieldForms/Toggles';

/* Important constant for each field form - tells backend which field subclass to load */
const FIELD_TYPE = 'SelectField';

/* eslint-disable object-curly-newline */
export function SelectFormFormInner(props) {
  const { handleSubmit, handleChange, handleBlur, values, setFieldValue, setFieldTouched, ...rest } = props;
  return (
    <Card>
      <Form>
        <CardContent>
          <Field
            component={TextField}
            onChange={value => setFieldValue('title', value.target.value)}
            fullWidth
            required
            disabled={props.isCommitting}
            id={`title:${values.id}`}
            name={`title:${values.id}`}
            value={values.title}
            label={<DiverstFormattedMessage {...messages.title} />}
          />
          <Box mb={2} />
          <Field
            component={TextField}
            onChange={value => setFieldValue('options_text', value.target.value)}
            fullWidth
            multiline
            disabled={props.isCommitting}
            id={`options_text:${values.id}`}
            name={`options_text:${values.id}`}
            value={values.options_text}
            label={<DiverstFormattedMessage {...messages.options} />}
          />
          <Toggles {...props} />
        </CardContent>
        <Divider />
        <CardActions>
          <DiverstSubmit isCommitting={props.isCommitting}>
            {
              props.edit
                ? (<DiverstFormattedMessage {...messages.update} />)
                : (<DiverstFormattedMessage {...messages.create} />)
            }
          </DiverstSubmit>
          <Button
            onClick={props.cancelAction}
            disabled={props.isCommitting}
          >
            <DiverstFormattedMessage {...messages.cancel} />
          </Button>
        </CardActions>
      </Form>
    </Card>
  );
}

export function SelectFormForm(props) {
  const initialValues = {
    title: props?.field?.title || '',
    options_text: props?.field?.options_text || '',
    id: props?.field?.id || '',
    show_on_vcard: props?.field?.show_on_vcard || true,
    alternative_layout: props?.field?.alternative_layout || false,
    private: props?.field?.private || false,
    required: props?.field?.required || false,
    add_to_member_list: props?.field?.add_to_member_list || false,
    type: FIELD_TYPE
  };

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.fieldAction(values);
      }}
    >
      {formikProps => <SelectFormFormInner {...props} {...formikProps} />}
    </Formik>
  );
}

SelectFormForm.propTypes = {
  fieldAction: PropTypes.func,
  field: PropTypes.object,
  isCommitting: PropTypes.bool,
  currentEnterprise: PropTypes.object,
};

SelectFormFormInner.propTypes = {
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  cancelAction: PropTypes.func,
  values: PropTypes.object,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  isCommitting: PropTypes.bool,
  edit: PropTypes.bool,
  links: PropTypes.shape({
  })
};

export default compose(
  memo,
)(SelectFormForm);
