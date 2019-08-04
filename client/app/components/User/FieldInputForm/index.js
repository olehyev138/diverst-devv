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

import CustomField from 'components/Shared/Fields/FieldInputs/Field';

const styles = theme => ({
  fieldInput: {
    width: '100%',
  },
});

/* eslint-disable object-curly-newline */
export function FieldInputFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  return (
    <Card>
      <Form>
        <FieldArray
          name='fields'
          render={arrayHelpers => (
            <CardContent>
              {values.field_data.map((fieldData, i) => {
                return (
                  <Grid item key={fieldData.id} className={props.classes.fieldInput}>
                    {Object.entries(fieldData).length !== 0 && <Field component={CustomField} fieldData={fieldData} />}
                  </Grid>
                );
              })}
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
    field_data: { default: [] }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        // props.updateFieldData(values);
      }}

      render={formikProps => <FieldInputFormInner {...props} {...formikProps} />}
    />
  );
}

FieldInputForm.propTypes = {
  updateFieldData: PropTypes.func,
  field_data: PropTypes.object,
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
