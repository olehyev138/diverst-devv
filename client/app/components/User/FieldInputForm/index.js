/**
 *
 * Field Input Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { FieldArray, Formik, Form } from 'formik';
import {
  Button, Card, CardActions, CardContent, Grid, Divider,
  TextField, Typography
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import messages from 'containers/User/messages';
import { buildValues } from 'utils/formHelpers';

import { serializeFieldData } from 'utils/customFieldHelpers';
import CustomField from 'components/Shared/Fields/FieldInputs/Field';

import DiverstSubmit from 'components/Shared/DiverstSubmit';

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
      <CardContent>
        <Typography component='h6'>
          <DiverstFormattedMessage {...messages.fields} />
        </Typography>
        <Typography color='secondary' component='h2'>
          <DiverstFormattedMessage {...messages.privacy} />
        </Typography>
      </CardContent>
      <Form>
        <FieldArray
          name='fields'
          render={_ => (
            <React.Fragment>
              {values.fieldData.map((fieldDatum, i) => (
                <div key={fieldDatum.id} className={props.classes.fieldInput}>
                  <Divider />
                  <CardContent>
                    {Object.entries(fieldDatum).length !== 0 && (
                      <CustomField
                        fieldDatum={fieldDatum}
                        fieldDatumIndex={i}
                        disabled={props.isCommitting}
                      />
                    )}
                  </CardContent>
                </div>
              ))}
            </React.Fragment>
          )}
        />
        <Divider />
        <CardActions>
          <DiverstSubmit isCommitting={props.isCommitting}>
            <DiverstFormattedMessage {...messages.fields_save} />
          </DiverstSubmit>
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
  isCommitting: PropTypes.bool,
};

FieldInputFormInner.propTypes = {
  formikProps: PropTypes.object,
  classes: PropTypes.object,
  isCommitting: PropTypes.bool,
};

export default compose(
  memo,
  withStyles(styles)
)(FieldInputForm);
