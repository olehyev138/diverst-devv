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
import { FieldArray, Formik, Form } from 'formik';
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
export function FieldInputFormInner({ formikProps, ...props }) {
  const { values } = formikProps;

  return (
    <Card>
      <Form>
        <FieldArray
          name='fields'
          render={_ => (
            <CardContent>
              {values.fields.map((field, i) => (
                <Grid item key={field.id} className={props.classes.fieldInput}>
                  {Object.entries(field).length !== 0 && (
                    renderFieldInput(field, values.field_data, formikProps)
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

  initialValues.field_data.forEach((datum) => {
    if (datum)
      try {
        const data = JSON.parse(datum.data);
        if (Array.isArray(data))
          datum.data = { value: data[0], label: data[0] }; /* eslint-disable-line no-param-reassign */
      } catch (e) { /* means field type is a plain string */ }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.updateFieldDataBegin({ field_data: values.field_data });
      }}

      render={formikProps => <FieldInputFormInner formikProps={formikProps} {...props} />}
    />
  );
}

FieldInputForm.propTypes = {
  updateFieldDataBegin: PropTypes.func,
  currentUser: PropTypes.object,
};

FieldInputFormInner.propTypes = {
  formikProps: PropTypes.object,
  classes: PropTypes.object
};

export default compose(
  memo,
  withStyles(styles)
)(FieldInputForm);
