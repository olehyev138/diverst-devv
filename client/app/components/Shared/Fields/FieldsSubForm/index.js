/**
 *
 * FieldsSubForm Component
 *
 *
 */

import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';

import {
  Button, Divider, Grid, Box, Typography
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import AddIcon from '@material-ui/icons/Add';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Shared/Field/messages';

import FieldForm from 'components/Shared/Fields/FieldSubForms/FieldForm';
import { FieldArray } from 'formik';
import { insertIntoArray } from 'utils/arrayHelpers';

const styles = theme => ({
  fieldsSubFormItem: {
    width: '100%',
  },
  fieldsSubFormItemDescription: {
    paddingTop: 8,
  },
  errorButton: {
    color: theme.palette.error.main,
  },
  fieldTitleButton: {
    textTransform: 'none',
  },
  fieldFormCollapse: {
    width: '100%',
  },
  fieldFormContainer: {
    width: '100%',
    padding: theme.spacing(1.5),
  },
});

export function FieldsSubForm(props, context) {
  const { classes, fieldsName, formikProps, ...rest } = props;

  const { textField, selectField, checkboxField, dateField, numberField } = props;
  const validType = { textField, selectField, checkboxField, dateField, numberField };

  const blankFieldPrototype = Object.freeze({
    id: undefined,
    type: undefined,
    title: '',
    show_on_vcard: true,
    options_text: '',
    min: '',
    max: '',
    private: false,
    required: false,
    _destroy: false,
  });

  const addButtons = arrayHelpers => (
    <Grid container spacing={3} justify='flex-end'>
      { textField && (
        <Grid item>
          <Button
            variant='contained'
            color='primary'
            size='small'
            onClick={() => arrayHelpers.push({ ...blankFieldPrototype, type: 'TextField' })}
            startIcon={<AddIcon />}
          >
            <DiverstFormattedMessage {...messages.newTextField} />
          </Button>
        </Grid>
      )}
      { selectField && (
        <Grid item>
          <Button
            variant='contained'
            color='primary'
            size='small'
            onClick={() => arrayHelpers.push({ ...blankFieldPrototype, type: 'SelectField' })}
            startIcon={<AddIcon />}
          >
            <DiverstFormattedMessage {...messages.newSelectField} />
          </Button>
        </Grid>
      )}
      { checkboxField && (
        <Grid item>
          <Button
            variant='contained'
            color='primary'
            size='small'
            onClick={() => arrayHelpers.push({ ...blankFieldPrototype, type: 'CheckboxField' })}
            startIcon={<AddIcon />}
          >
            <DiverstFormattedMessage {...messages.newCheckBoxField} />
          </Button>
        </Grid>
      )}
      { dateField && (
        <Grid item>
          <Button
            variant='contained'
            color='primary'
            size='small'
            onClick={() => arrayHelpers.push({ ...blankFieldPrototype, type: 'DateField' })}
            startIcon={<AddIcon />}
          >
            <DiverstFormattedMessage {...messages.newDateField} />
          </Button>
        </Grid>
      )}
      { numberField && (
        <Grid item>
          <Button
            variant='contained'
            color='primary'
            size='small'
            onClick={() => arrayHelpers.push({ ...blankFieldPrototype, type: 'NumericField' })}
            startIcon={<AddIcon />}
          >
            <DiverstFormattedMessage {...messages.newNumericField} />
          </Button>
        </Grid>
      )}
    </Grid>
  );

  const fieldForm = props => (
    props.field && !props?.field?._destroy ? (
      <React.Fragment key={props.index}>
        <FieldForm
          {...props}
        />
      </React.Fragment>
    ) : null
  );

  fieldForm.propTypes = {
    index: PropTypes.number,
    field: PropTypes.shape({
      _destroy: PropTypes.bool,
    }),
  };

  return (
    <FieldArray
      name={fieldsName}
      render={arrayHelpers => (
        <React.Fragment>
          <Grid container justify='space-between'>
            <Grid item>
              <Typography variant='h5' color='primary'>
                <DiverstFormattedMessage {...messages.header} />
              </Typography>
            </Grid>
            <Grid item>
              { addButtons(arrayHelpers) }
            </Grid>
          </Grid>
          <Box mb={1} />
          {insertIntoArray(
            formikProps.values[fieldsName].map(
              (field, index) => fieldForm({ arrayHelpers, formikProps, field, index, fieldsName })
            ).filter(a => a), (
              <React.Fragment>
                <Box mb={2} />
                <Divider />
                <Box mb={2} />
              </React.Fragment>
            ),
            true,
            false,
          )}
        </React.Fragment>
      )}
    />
  );
}

FieldsSubForm.propTypes = {
  classes: PropTypes.object,
  formikProps: PropTypes.object,
  fieldsName: PropTypes.string,
  textField: PropTypes.bool,
  selectField: PropTypes.bool,
  checkboxField: PropTypes.bool,
  dateField: PropTypes.bool,
  numberField: PropTypes.bool,
};

export default compose(
  memo,
  withStyles(styles),
)(FieldsSubForm);
