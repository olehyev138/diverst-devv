import React from 'react';
import { compose } from 'redux';
import { withStyles } from '@material-ui/core/styles';
import PropTypes from 'prop-types';

import { Button, FormControl, FormHelperText, FormLabel, Grid, Typography } from '@material-ui/core';

import { DirectUploadProvider } from 'react-activestorage-provider';

import config from 'app.config';
import AuthService from 'utils/authService';

const styles = theme => ({
  fileInput: {
    display: 'none',
  },
  uploadSection: {
    paddingTop: 8,
  },
  fileName: {
    fontSize: 16,
    verticalAlign: 'middle',
  },
});

const inputRef = React.createRef();

const apiURL = new URL(config.apiUrl);

export function DiverstFileInput(props) {
  const { classes, form, handleUploadSuccess, handleUploadError, ...rest } = props;

  /* eslint-disable-next-line prefer-destructuring */
  const apiKey = config.apiKey;
  const userToken = AuthService.getJwt();

  // Form Control props
  const {
    disabled,
    error,
    fullWidth,
    hiddenLabel,
    margin,
    required,
    variant,
    value,
    multiple,
    ...inputProps
  } = rest;

  return (
    <React.Fragment>
      <DirectUploadProvider
        multiple={multiple}
        origin={{
          host: apiURL.hostname,
          port: apiURL.port,
          protocol: apiURL.protocol.slice(0, -1),
        }}
        headers={{
          'Diverst-APIKey': apiKey,
          'Diverst-UserToken': userToken,
        }}
        onBeforeStorageRequest={({ id, file, xhr }) => {
          // Necessary as the `headers` prop doesn't seem to pass the headers for the storage request
          // See: https://github.com/cbothner/react-activestorage-provider/issues/50
          xhr.setRequestHeader('Diverst-APIKey', apiKey);
          xhr.setRequestHeader('Diverst-UserToken', userToken);
        }}
        onSuccess={(object) => {
          if (!object || object.length <= 0)
            return;

          if (multiple)
            form.setFieldValue(props.id, object);
          else
            form.setFieldValue(props.id, object.pop());

          if (handleUploadSuccess)
            handleUploadSuccess(object);
        }}
        onError={handleUploadError}
        render={({ handleUpload, uploads, ready }) => (
          <React.Fragment>
            <FormControl
              disabled={disabled || !ready}
              error={error}
              fullWidth={fullWidth}
              hiddenLabel={hiddenLabel}
              margin={margin}
              required={required}
              variant={variant}
            >
              <FormLabel
                htmlFor={props.id}
                disabled={disabled || !ready}
                error={error}
                required={required}
              >
                {props.label}
              </FormLabel>
              <input
                accept='image/*'
                id={props.id}
                type='file'
                className={classes.fileInput}
                ref={inputRef}
                disabled={disabled || !ready}
                onChange={e => handleUpload(e.currentTarget.files)}
                {...inputProps}
              />
              <Grid container spacing={2} className={classes.uploadSection} alignItems='center'>
                <Grid item>
                  <Button
                    component='span'
                    color='secondary'
                    variant='contained'
                    onClick={() => inputRef.current.click()}
                    disabled={disabled || !ready}
                  >
                    Upload File
                  </Button>
                </Grid>
                <Grid item xs>
                  {uploads.map((upload) => {
                    switch (upload.state) {
                      case 'waiting':
                        return (
                          <Typography variant='h6' className={classes.fileName} color='textSecondary' key={upload.id}>
                            <span>Waiting to upload </span>
                            {upload.file.name}
                          </Typography>
                        );
                      case 'uploading':
                        return (
                          <Typography variant='h6' className={classes.fileName} color='textSecondary' key={upload.id}>
                            <span>Uploading </span>
                            {upload.file.name}
                            <span>: </span>
                            {upload.progress}
                            <span>%</span>
                          </Typography>
                        );
                      case 'error':
                        return (
                          <Typography variant='h6' className={classes.fileName} color='textSecondary' key={upload.id}>
                            <span>Error uploading </span>
                            {upload.file.name}
                            <span>: </span>
                            {upload.error}
                          </Typography>
                        );
                      case 'finished':
                        return (
                          <Typography variant='h6' className={classes.fileName} color='textSecondary' key={upload.id}>
                            <span>Finished uploading </span>
                            {upload.file.name}
                          </Typography>
                        );
                      default:
                        return (<React.Fragment />);
                    }
                  })}

                  {value && (
                    <Typography variant='h6' className={classes.fileName}>
                      File has been uploaded
                    </Typography>
                  )}

                  {!value && (
                    <Typography variant='h6' className={classes.fileName}>
                      Nothing attached
                    </Typography>
                  )}
                </Grid>
              </Grid>
              {props.showHelperText && (
                <FormHelperText
                  id={`${props.id}-helper-text`}
                  disabled={disabled || !ready}
                  error={error}
                  required={required}
                  variant={variant}
                >
                  {props.helperText}
                </FormHelperText>
              )}
            </FormControl>
          </React.Fragment>
        )}
      />
    </React.Fragment>
  );
}

DiverstFileInput.propTypes = {
  id: PropTypes.string,
  name: PropTypes.string,
  multiple: PropTypes.bool,
  classes: PropTypes.object,
  form: PropTypes.object,
  label: PropTypes.node,
  value: PropTypes.any,
  helperText: PropTypes.node,
  showHelperText: PropTypes.bool,
  handleUploadSuccess: PropTypes.func,
  handleUploadError: PropTypes.func,
};

export default compose(
  withStyles(styles),
)(DiverstFileInput);
