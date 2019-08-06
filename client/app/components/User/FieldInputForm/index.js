/**
 *
 * Field Input Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';

import { FormattedMessage } from 'react-intl';
import { Field, FieldArray, Formik, Form } from 'formik';
import {
  Button, Card, CardActions, CardContent, Grid, TextField
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/User/messages';
import { buildValues } from 'utils/formHelpers';

import renderFieldInput from 'utils/customFieldHelpers';
import CustomField from 'components/Shared/Fields/FieldInputs/Field';

const styles = theme => ({
  fieldInput: {
    width: '100%',
  },
});

/* eslint-disable-next-line object-curly-newline */
export function FieldInputFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  return (
    <Card>
      <Form>
        <FieldArray
          name='fields'
          render={arrayHelpers => (
            <CardContent>
              {values.fields.map((field, i) => (
                <Grid item key={field.id} className={props.classes.fieldInput}>
                  {Object.entries(field).length !== 0 && (
                    renderFieldInput(field, values.field_data, { handleChange })
                  )}
                </Grid>
              ))}
            </CardContent>
          )}
        />
        <CardActions>
          <Button
            color='primary'
            type='submit'
          >
            Save
          </Button>
        </CardActions>
      </Form>
    </Card>
  );
}

export function FieldInputForm(props) {
  const user = dig(props, 'user');
  const initialValues = buildValues(user, {
    field_data: { default: [] },
    fields: { default: [] }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.updateFieldDataBegin({ field_data: values.field_data });
      }}

      render={formikProps => <FieldInputFormInner {...props} {...formikProps} />}
    />
  );
}

FieldInputForm.propTypes = {
  updateFieldDataBegin: PropTypes.func,
  currentUser: PropTypes.object,
};

FieldInputFormInner.propTypes = {
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  classes: PropTypes.object,
  user: PropTypes.object
};

export default compose(
  memo,
  withStyles(styles)
)(FieldInputForm);
