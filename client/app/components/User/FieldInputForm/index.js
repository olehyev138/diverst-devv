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
  Button, Card, CardActions, CardContent, Grid,
  TextField
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/User/messages';
import { buildValues } from 'utils/formHelpers';

import { serializeFieldData } from 'utils/customFieldHelpers';
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
              {values.fieldData.map((fieldDatum, i) => (
                <Grid item key={fieldDatum.id} className={props.classes.fieldInput}>
                  {Object.entries(fieldDatum).length !== 0 && (
                    <CustomField fieldDatum={fieldDatum} fieldDatumIndex={i} />
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

      render={formikProps => <FieldInputFormInner formikProps={formikProps} {...props} />}
    />
  );
}

FieldInputForm.propTypes = {
  updateFieldDataBegin: PropTypes.func,
  fieldData: PropTypes.array,
};

FieldInputFormInner.propTypes = {
  formikProps: PropTypes.object,
  classes: PropTypes.object
};

export default compose(
  memo,
  withStyles(styles)
)(FieldInputForm);