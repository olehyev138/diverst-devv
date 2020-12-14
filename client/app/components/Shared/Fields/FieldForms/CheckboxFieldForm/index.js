/**
 *
 *  CheckboxField Form Component
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
import { buildValues } from 'utils/formHelpers';

/* Important constant for each field form - tells backend which field subclass to load */
const FIELD_TYPE = 'CheckboxField';

/* eslint-disable object-curly-newline */
export function CheckboxFieldFormInner(props) {
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
            required
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
          <DiverstSubmit isCommitting={props.isCommitting} disabled={!values.options_text.trim()}>
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

export function CheckboxFieldForm(props) {
  const initialValues = buildValues(props.field, {
    title: { default: '' },
    options_text: { default: '' },
    id: { default: '' },
    show_on_vcard: { default: true },
    alternative_layout: { default: false },
    private: { default: false },
    required: { default: false },
    add_to_member_list: { default: false },
    type: { default: FIELD_TYPE },
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.fieldAction(values);
      }}
    >
      {formikProps => <CheckboxFieldFormInner {...props} {...formikProps} />}
    </Formik>
  );
}

CheckboxFieldForm.propTypes = {
  fieldAction: PropTypes.func,
  field: PropTypes.object,
  isCommitting: PropTypes.bool,
  currentEnterprise: PropTypes.object,
};

CheckboxFieldFormInner.propTypes = {
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
)(CheckboxFieldForm);
