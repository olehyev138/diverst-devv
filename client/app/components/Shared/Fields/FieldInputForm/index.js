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

import { withStyles } from '@material-ui/styles';
import {
  CardContent, Divider, Typography
} from '@material-ui/core';

import CustomField from 'components/Shared/Fields/FieldInputs/Field';

const styles = theme => ({
  fieldInput: {
    width: '100%',
  },
});

export function FieldInputForm({ formikProps, messages, ...props }) {
  const { values } = formikProps;

  return (
    <React.Fragment>
      <CardContent>
        <Typography component='h6'>
          <DiverstFormattedMessage {...messages.fields} />
        </Typography>
        <Typography color='secondary' component='h2'>
          <DiverstFormattedMessage {...messages.preface} />
        </Typography>
      </CardContent>
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
    </React.Fragment>
  );
}

FieldInputForm.propTypes = {
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
)(FieldInputForm);
