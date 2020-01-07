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
  Button, Card, CardActions, CardContent, Grid, Divider,
  TextField, Typography
} from '@material-ui/core';

import { buildValues } from 'utils/formHelpers';

import { serializeFieldData } from 'utils/customFieldHelpers';
import CustomField from 'components/Shared/Fields/FieldInputs/Field';

import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';

const styles = theme => ({
  fieldInput: {
    width: '100%',
  },
});

/* eslint-disable-next-line object-curly-newline */
export function FieldInputFormInner({ formikProps, messages, join, noCard, ...props }) {
  const { values } = formikProps;

  const { isFormLoading, edit, fieldData } = props;

  const arrayForm = (
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
  );

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

  const header = (
    <CardContent>
      <Typography component='h6'>
        <DiverstFormattedMessage {...messages.fields} />
      </Typography>
      <Typography color='secondary' component='h2'>
        <DiverstFormattedMessage {...messages.preface} />
      </Typography>
    </CardContent>
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

  let toReturn = arrayForm;

  if (!join) {
    toReturn = (
      <React.Fragment>
        {toReturn}
        {submitButton}
      </React.Fragment>
    );

    toReturn = formWrapper(toReturn);
  }
  toReturn = (
    <React.Fragment>
      {header}
      {toReturn}
    </React.Fragment>
  );

  if (!noCard)
    toReturn = cardWrapper(toReturn);

  if (!join)
    toReturn = loaderWrapper(toReturn);

  return toReturn;
}

export function FieldInputForm(props) {
  const initialValues = buildValues({ fieldData: props.fieldData }, {
    fieldData: { default: [] },
  });

  if (props.join)
    return (<FieldInputFormInner formikProps={props.formikProps} {...props} />);
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

FieldInputForm.propTypes = {
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
)(FieldInputForm);
