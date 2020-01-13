/**
 *
 * Field
 *
 * - Acts as the 'super' component
 * - Given a field object and renders the appropriate field input
 *
 * - We use Formiks 'connect' function to hook into Formik's context
 * - This way we can build our own custom Formik fields
 */

import React from 'react';
import PropTypes from 'prop-types';
import dig from 'object-dig';

import { compose } from 'redux/';
import { withStyles } from '@material-ui/core/styles';
import CustomText from 'components/Shared/Fields/FieldDisplays/TextField';
import CustomDate from 'components/Shared/Fields/FieldDisplays/DateField';
import CustomSelect from 'components/Shared/Fields/FieldDisplays/SelectField';
import CustomCheckbox from 'components/Shared/Fields/FieldDisplays/CheckboxField';

const styles = theme => ({
  cell: {

  },
  dataHeaders: {

  },
  data: {

  },
});

const CustomFieldShow = (props) => {
  const fieldData = dig(props, 'fieldDatum');
  const { classes } = props;

  const renderField = (fieldData) => {
    switch (dig(fieldData, 'field', 'type')) {
      case 'TextField':
        return (<CustomText {...props} inputType='' classes={classes} />);
      case 'NumericField':
        return (<CustomText {...props} inputType='number' classes={classes} />);
      case 'DateField':
        return (<CustomDate {...props} classes={classes} />);
      case 'SelectField':
        return (<CustomSelect {...props} classes={classes} />);
      case 'CheckboxField':
        return (<CustomCheckbox {...props} classes={classes} />);
      default:
        return null;
    }
  };

  return renderField(fieldData);
};

CustomFieldShow.propTypes = {
  classes: PropTypes.object,
  fieldDatum: PropTypes.object,
  fieldDatumIndex: PropTypes.number
};

export default compose(
  withStyles(styles)
)(CustomFieldShow);
